class Pathfinder
  class TightLoopReducer
    private

    attr_reader :graph

    public

    def initialize graph
      @graph = graph
    end

    def reduce
      edge_for_removal = graph.edges.select { |edge| edge.first == edge.last }.first

      if edge_for_removal
        graph.remove_edge edge_for_removal
        true
      else
        false
      end
    end
  end
end
