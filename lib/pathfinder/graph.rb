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

    def self.from_multi_line_string mls
      new_graph = self.new
      mls.each { |segment| new_graph.add_edge segment }

      new_graph
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

    def contains_edge? e
      graph.contains_edge e
    end

    def vertices; graph.vertices; end

    def contains_vertex? v
      graph.contains_vertex v
    end

    def remove_vertex v
      graph.remove_vertex v
    end

    def out_edges v
      graph.get_out_edges(v)
    end

    def edge_count(v = :whole_graph)
      if v == :whole_graph
        graph.get_edge_count
      else
        Array(graph.get_out_edges(v)).length
      end
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

    def endpoints e
      Array(graph.get_endpoints(e).toArray)
    end

    def other_endpoint(v, e)
      (endpoints(e) - [v]).first
    end

    def edges
      graph.edges
    end

    def edge(v1, v2)
      graph.find_edge v1, v2
    end

    def successors(v)
      graph.get_successors(v)
    end

    def to_s
      factory = GeometryFactory.new PrecisionModel.new, 4326
      linestrings = Array(edges).map(&:jts_line_string).to_java(::LineString)
      factory.create_multi_line_string(linestrings).to_s
    end
  end
end