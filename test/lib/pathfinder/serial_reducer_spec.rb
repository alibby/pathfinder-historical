
require_relative '../../test_helper'

describe Pathfinder::SerialReducer do
  describe "a single linestring" do
    before do
      @graph = graph_from_wkt "MULTILINESTRING((0 1, 1 1),(0 0, -1 -1))"
      @reducer = Pathfinder::SerialReducer.new @graph
    end

    it "should perform no reductions" do
      @graph.edges.length.must_equal 2
      @reducer.reduce.must_equal false
      @graph.edges.length.must_equal 2
      # @graph.edges.first.to_s.must_equal "LINESTRING (0 0, 0 1, 1 1)"
    end
  end

  describe "badly sequenced reduction" do
    before do
      @graph = graph_from_wkt "MULTILINESTRING((0 1, 1 1),(0 0, 0 1))"
      @reducer = Pathfinder::SerialReducer.new @graph
    end

    it "produce a single linestring LINESTRING (0 0, 0 1, 1 1)" do
      @graph.edges.length.must_equal 2
      @reducer.reduce.must_equal true
      @graph.edges.length.must_equal 1
      @graph.edges.first.to_s.must_equal "LINESTRING (0 0, 0 1, 1 1)"
    end
  end
end