class Pathfinder
  class Face
    include Enumerable

    private

    attr_reader :graph, :vertices

    public

    def initialize graph, face_vertices
      @graph = graph
      @vertices = face_vertices
      @original_star = @vertices.first
      @furthest_edge_pair = nil

      align_by_furthest_vertices!
    end

    def align_by_furthest_vertices!
      start_offset = vertices.index furthest_vertex_pair.first
      last_offset = vertices.length + start_offset - 1

      @vertices = start_offset.upto( last_offset )
        .map { |offset| offset % vertices.length }
        .map { |adjusted_offset| vertices[adjusted_offset] }
      @vertices << @vertices.first
    end

    def longest_edge_multi_line_strings
      i1, i2 = furthest_vertex_pair.map { |v| vertices.index v }

      [ mls_from_offsets(i1, i2), mls_from_offsets(i2, vertices.length() - 1) ]
    end

    def each &blk
      @vertices.each &blk
    end

    def off_face_edges v
      successors = Array(graph.successors v)
      (successors - vertices).map { |v2| graph.edge(v, v2) }
    end

    private

    def mls_from_offsets(o1, o2)
      line_strings = o1.upto(o2)
        .each_cons(2)
        .map { |a,b| [vertices[a], vertices[b]] }
        .map { |a,b| graph.edge a,b }

      factory = GeometryFactory.new PrecisionModel.new, 4326

      jts_line_strings = line_strings.map { |line_string| line_string.jts_line_string }.to_java(::LineString)
      Pathfinder::MultiLineString.new(factory.create_multi_line_string jts_line_strings)
    end

    public

    def furthest_vertex_pair
      @furthest_edge_pair ||= @vertices.combination(2)
        .map { |a,b| [ a.distance(b), [a,b] ] }
        .sort { |a,b| a.first <=> b.first }
        .last
        .last

      @furthest_edge_pair
    end

    def to_s
      @vertices.map { |v| v.to_s }.join(" ")
    end
  end
end