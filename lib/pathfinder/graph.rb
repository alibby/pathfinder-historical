
require "java"

java_import "edu.uci.ics.jung.graph.UndirectedSparseMultigraph"
java_import "edu.uci.ics.jung.graph.util.Pair"
java_import "edu.uci.ics.jung.graph.util.EdgeType"

require 'pp'

class Pathfinder
  class Graph

    private

    attr_reader :graph

    public

    def initialize
      @graph = UndirectedSparseMultigraph.new
    end

    def self.from_topology topology
      new_graph = self.new
      topology.segments.each { |segment| new_graph.add_edge segment }

      new_graph
    end

    def add_edge e
      raise ArgumentError.new('edge must respond to #first()') unless e.respond_to? :first
      raise ArgumentError.new('edge must respond to #last()') unless e.respond_to? :last
      graph.add_edge e, Pair.new(e.first, e.last)
    end

    def remove_edge e
      graph.remove_edge e
    end

    def vertices; graph.vertices; end

    def out_edges v
      graph.get_out_edges(v)
    end

    # Returns a tuple of parallel edges (if any)
    # starting from vertex v1.
    def parallel_edges(v1)
      successors = Array(graph.get_successors(v1))

      successors
        .map { |v2| Array(graph.find_edge_set(v1, v2)) }
        .select { |potential_pair| potential_pair.length > 1 }
        .flatten

    end

    # Returns the first parallel edge pair it finds.  Falsy
    # otherwise.
    #
    def find_an_edge_pair
      vertices
        .map { |v| parallel_edges v }
        .find { |potential_pair| potential_pair.length > 1 }
    end

    def endpoints e
      Array(graph.get_endpoints(e).toArray)
    end

    def edges
      graph.edges
    end

    def to_s
      edges.map { |edge|
        edge.to_s
      }.join("\n")
    end
  end
end