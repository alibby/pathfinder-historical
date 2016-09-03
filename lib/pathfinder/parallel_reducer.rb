
class Pathfinder
  class ParallelReducer < Reducer
    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
      @excluded_pairs = Set.new
      @modified = false
    end

    def reduce
      @excluded_pairs.clear
      @modified = false
      while(! (pair = find_an_edge_pair).nil?) do
        edge1, edge2 = pair

        dist = edge1.hausdorff_distance edge2

        if too_far_apart? pair
          @excluded_pairs << pair
          next
        end
        @modified = true
        new_edge = LineString.average edge1, edge2
        graph.remove_edge edge1
        graph.remove_edge edge2
        graph.add_edge new_edge
        break
      end

      @modified
    end

    private

    def find_an_edge_pair
      graph.vertices
        .map { |v| graph.parallel_edges v }
        .reject { |potential_pair| pair_excluded? potential_pair }
        .find { |potential_pair| potential_pair.length > 1 }
    end

    def pair_excluded? pair
      @excluded_pairs.include? pair
    end

  end
end
