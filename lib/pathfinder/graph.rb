
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

    def vertices; graph.vertices; end

    def out_edges v
      graph.get_out_edges(v)
    end

    def parallel_edges(v1)
      oe = out_edges v1

      return false if oe.length < 2

      h = Hash.new
      oe.each { |e|
        v2 = (endpoints(e) - [v1]).first.to_s
        h[v2] ||= []
        h[v2] << e
      }
      h.select { |k,v| v.length > 1 }
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