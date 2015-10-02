class Pathfinder
  class FaceReducer < Reducer

    private

    attr_reader :visited

    public

    def initialize g
      @visited = Set.new
      super g
    end

    def reduce
      modified! false
      visited.clear
      logger = Pathfinder.logger 'FaceReducer#reduce'

      loop do
        break unless face = find_a_face
        logger.debug "Face: #{face}"
        pair = face.longest_edge_multi_line_strings

        next if too_far_apart? pair

        reduce_face face
      end

      logger.debug "#reduce returning modifcation status #{modified?}"
      modified?
    end

    private

    def find_a_face
      logger = Pathfinder.logger 'FaceReducer#find_a_face'

      # logger.debug('find_a_face') { visited.map { |p| p.to_s }.join ' ' }
      graph.vertices.each do |start_vertex|
        # logger.debug "#{visited?(start_vertex) ? "Visited" : "Unvisited"} Vertex: #{start_vertex}"
        next if visited? start_vertex
        visit! start_vertex
        face_vertices = traverse_face start_vertex
        next unless face_vertices
        visit! face_vertices

        if face_vertices.length < 3
          logger.warn "Danger, found small face - #{face_vertices.map { |p| p.to_s }.join(' ')}"
          next
        end

        if face_vertices[1..-2] != face_vertices[1..-2].uniq
          logger.warn "Danger, face has internal point duplication"
          next
        end

        # logger.debug "Face vertices: #{ face_vertices.map { |v| v.to_s }.join(' ') }"

        return(Face.new(graph, face_vertices)) if(face_vertices)
      end
      logger.debug "returning nil, didn't find a face"
      return nil
    end

    def traverse_face(start_v, current_v = start_v, accum = [])
      return false if accum.length > 4
      return accum if current_v == start_v and accum.length > 0

      successors = Array(graph.successors current_v)
      (successors - [accum.last]).each do |next_v|
        face = traverse_face(start_v, next_v, accum + [current_v])
        return face if face
      end

      return false
    end

    def reduce_face face
      logger = Pathfinder.logger 'reduce_face'
      begin
        pair = face.longest_edge_multi_line_strings

        averaged_mls = average_line *pair
        averaged_mls.each { |ls| add_edge ls }
        join_adjacents_to_averaged_line face, averaged_mls
        pair.each { |mls|
          mls.each { |ls|
            # logger.debug ls.first.to_s
            # logger.debug ls.last.to_s
            e = graph.edge ls.first, ls.last
            # logger.debug e.to_s
            remove_edge e if e
          }
        }

      rescue AssertionFailedException => e
        logger.warn(self.class.name) { e.to_s }
      end
    end

    # def average_mls mls1, mls2
    #   logger = Pathfinder.logger 'averaged_mls'
    #   indexes = (mls1.endpoint_indexes + mls2.endpoint_indexes).sort.uniq

    #   logger.debug { "Indexes: #{indexes}" }

    #   averaged_line = average_line mls1, mls2

    #   logger = Pathfinder.logger
    #   logger.debug { "Averaged Line: #{averaged_line}" }
    #   MultiLineString.break_line_string(averaged_line, indexes).each do |ls|
    #     add_edge ls
    #   end

    #   averaged_line
    # end

    def average_line mls1, mls2
      logger = Pathfinder.logger "FaceReducer#average_line"
      indexes = (mls1.endpoint_indexes + mls2.endpoint_indexes).sort.uniq
      logger.debug "Indexes for new segment: #{indexes}"

      ls1 = MultiLineString.ls_from_mls mls1
      ls2 = MultiLineString.ls_from_mls mls2

      averaged_line = LineString.average ls1, ls2
      logger.debug "Averaged Line: #{averaged_line}"
      MultiLineString.break_line_string(averaged_line, indexes)
    end

    def join_adjacents_to_averaged_line face, averaged_mls
      logger = Pathfinder.logger "FaceReducer#join_adjacents_to_averaged_line"
      factory = Pathfinder.geometry_factory

      furthest_pair = face.furthest_vertex_pair

      for_removal = Set.new
      face.longest_edge_multi_line_strings.each do |mls|
        logger.debug "Working with MLS item: "
        logger.debug mls.to_s
        first_points = mls.map { |line| line.first } - furthest_pair
        first_points.each do |pt|
          logger.debug "Working with pt: #{pt}"
          index = mls.index pt
          logger.debug "Index for new point on mls is: #{index}"
          new_pt = averaged_mls.point_at index
          logger.debug "New Point: #{new_pt}"
          face.off_face_edges(pt).each do |edge|
            remove_edge edge
            logger.debug "Off Face Edge: "
            logger.debug edge.to_s
            r_pts = Array(edge)
            r_pts[ r_pts.first == pt ? 0 : -1 ] = new_pt

            replacement_edge = factory.create_line_string r_pts.map(&:coordinate).to_java(Coordinate)
            # logger.debug(self.class.name) { "Replacement edge is:" }
            # logger.debug(self.class.name) { replacement_edge.to_s }
            add_edge Pathfinder::LineString.new replacement_edge
            for_removal << edge
          end
        end

        # for_removal.each { |edge| remove_edge edge }
      end
    end

    def visited? vertex
      @visited.include? vertex
    end

    def visit! vertex_or_array
      Array(vertex_or_array).each { |vertex| @visited << vertex }
    end
  end
end