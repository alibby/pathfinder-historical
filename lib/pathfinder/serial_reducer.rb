class Pathfinder
  class SerialReducer
    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
    end

    def reduce
      vertices_to_remove = []

      graph.vertices.each do |vertex|
        next if graph.edge_count(vertex) != 2

        edge1, edge2 = consecutive_edges_through_vertex vertex

        puts "=" * 80
        puts "Candidate vertex: #{vertex}"
        puts edge1
        puts edge2

        new_edge = edge_from_consecutive_edges edge1, edge2


        graph.add_edge new_edge

        graph.remove_edge edge1
        graph.remove_edge edge2

        vertices_to_remove << vertex if graph.contains_vertex? vertex
      end

      vertices_to_remove.each do |v|
        graph.remove_vertex v
      end
    end

    private

    def consecutive_edges_through_vertex vertex
      edge1, edge2 = graph.out_edges(vertex)

      if edge1.last != edge1.first
        [edge1, edge2]
      else
        [edge2, edge1]
      end
    end

    def edge_from_consecutive_edges edge1, edge2
      pm = PrecisionModel.new
      factory = GeometryFactory.new pm, 4326

      coordinates_for_new_edge = (Array(edge1.coordinates) + Array(edge2.coordinates)[1..-1]).to_java(Coordinate)
      jts_linestring = factory.create_line_string coordinates_for_new_edge
      Pathfinder::LineString.new jts_linestring
    end
  end
end
