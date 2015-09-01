
require "java"

java_import "edu.uci.ics.jung.graph.UndirectedSparseMultigraph"
java_import "edu.uci.ics.jung.graph.util.Pair"
java_import "edu.uci.ics.jung.graph.util.EdgeType"


class Pathfinder
  class Graph
    def initialize
      @g = UndirectedSparseMultigraph.new
    end

    def add_edge e, v1, v2
      @g.add_edge e, Pair.new(v1, v2)
    end

    def vertices; @g.vertices; end

    def out_edges v
      @g.get_out_edges(v)
    end

    def edge_pair(v)

    end
  end
end