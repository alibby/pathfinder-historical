class Pathfinder
  class TightLoopReducer
    private

    attr_reader :graph

    public

    def initialize graph
      @graph = graph
    end

    def reduce
      for_removal = graph.edges.select { |edge| edge.first == edge.last }
      for_removal.each { |edge|
        graph.remove_edge edge
      }

      for_removal.length > 0
    end
  end
end