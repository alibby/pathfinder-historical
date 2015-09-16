class Pathfinder
  class FaceReducer < Reducer
    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
      @modified = false
      @visited = []
    end

    def indexes_for_multi_line_string mls
      index = LengthIndexedLine.new mls.jts_multi_line_string
      indexes = mls
        .map { |ls| [ls.first, ls.last] }
        .flatten
        .uniq
        .map { |pt| index.index_of pt.coordinate }
    end

    def visited? face
      @visited.include? face
    end

    def reduce
      @modified = false

      face = find_a_face
      return false unless face
      return false if visited? face

      furthest_pair = face.furthest_vertex_pair
      v1, v2 = furthest_pair

      pair = face.longest_edge_multi_line_strings

      if too_far_apart? pair
        @visited << face
        return false
      end

      mls1, mls2 = pair
      averaged_line = LineString.average ls_from_mls(mls1), ls_from_mls(mls2)
      indexes = (indexes_for_multi_line_string(mls1) + indexes_for_multi_line_string(mls2)).sort
      averaged_mls = MultiLineString.break_line_string averaged_line, indexes

      averaged_mls.each { |ls| add_edge ls }

      factory = GeometryFactory.new PrecisionModel.new, 4326
      indexed_avg = LengthIndexedLine.new averaged_line.jts_line_string

      [mls1, mls2].each do |mls|
        indexed_mls = LengthIndexedLine.new  mls.jts_multi_line_string
        points = mls.map { |line| line.first }[1..-1]
        points.each do |pt|
          index = indexed_mls.index_of(pt.coordinate)
          new_pt = factory.create_point indexed_avg.extract_point index

          face.off_face_edges(pt).each do |edge|
            r_pts = Array(edge)
            r_pts[ r_pts.first == pt ? 0 : -1 ] = new_pt

            replacement_edge = factory.create_line_string r_pts.map(&:coordinate).to_java(Coordinate)
            add_edge Pathfinder::LineString.new replacement_edge
            remove_edge edge
          end
        end
      end

      for_removal = face.each_cons(2).map { |a,b| graph.edge(a,b) }
      for_removal.each { |edge| remove_edge edge }

      @modified
    end

    private

    def remove_edge line_string
      logger = Pathfinder.logger

      if ! graph.remove_edge line_string
        logger.error(self.class.name) { "Edge remove failed: #{line_string}" }
      else
        @modified = true
      end

      @modified
    end

    def add_edge line_string
      logger = Pathfinder.logger

      if ! graph.add_edge line_string
        logger.error(self.class.name) { "Edge addition failed: #{line_string}" }
      else
        @modified = true
      end

      @modified
    end

    def ls_from_mls mls
      points = []
      mls.each { |ls| points += Array(ls) }
      factory = GeometryFactory.new PrecisionModel.new, 4326
      coordinates = points.uniq.map(&:coordinate).to_java Coordinate
      Pathfinder::LineString.new(factory.create_line_string coordinates)
    end

    def find_a_face
      graph.vertices.each do |start_vertex|
        face_vertices = traverse_face start_vertex
        return Face.new(graph, face_vertices) if face_vertices
      end
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
  end
end