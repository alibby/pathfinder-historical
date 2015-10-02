class Pathfinder
  class SerialReducer < Reducer

    def reduce
      modified! false
      logger = Pathfinder.logger "#{self.class.name}#reduce"
      vertices_to_remove = []

      graph.vertices.each do |vertex|
        next if graph.edge_count(vertex) != 2
        edge1, edge2 = consecutive_edges_through_vertex vertex
        logger.debug "Found edges to reduce through #{vertex}"
        logger.debug "edge 1: #{edge1}"
        logger.debug "edge 2: #{edge2}"
        new_edge = edge_from_consecutive_edges edge1, edge2

        add_edge new_edge
        remove_edge edge1
        remove_edge edge2
      end

      modified?
    end

    private


    def consecutive_edges_through_vertex vertex
      edge1, edge2 = graph.out_edges(vertex)


      if edge1.last == vertex
        [edge1, edge2]
      else
        [edge2, edge1]
      end
    end

    def edge_from_consecutive_edges edge1, edge2
      factory = Pathfinder.geometry_factory
      coordinates_for_new_edge = (Array(edge1.coordinates) + Array(edge2.coordinates)[1..-1]).to_java(Coordinate)
      jts_line_string = factory.create_line_string coordinates_for_new_edge
      Pathfinder::LineString.new jts_line_string
    end
  end
end
