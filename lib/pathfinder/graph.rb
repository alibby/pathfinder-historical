
require "java"

java_import "edu.uci.ics.jung.graph.UndirectedSparseMultigraph"
java_import "edu.uci.ics.jung.graph.util.Pair"
java_import "edu.uci.ics.jung.graph.util.EdgeType"


class Pathfinder
  class Graph
    def initialize
      @g = UndirectedSparseMultigraph.new
    end

    def self.from_topology topology
      g = self.new
      topology.segments.each { |segment| g.add_edge segment }

      g
    end

    def add_edge e
      raise ArgumentError.new('edge must respond to #first()') unless e.respond_to? :first
      raise ArgumentError.new('edge must respond to #last()') unless e.respond_to? :last
      @g.add_edge e, Pair.new(e.first, e.last)
    end

    def vertices; @g.vertices; end

    def out_edges v
      @g.get_out_edges(v)
    end

    def edge_pair(v)

    end

    def edges
      @g.edges
    end
  end
end