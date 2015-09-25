
require_relative '../../test_helper'

def graph_from_wkt wkt
  rdr = WKTReader.new(GeometryFactory.new(PrecisionModel.new, 4326))
  initial = rdr.read(wkt)
  mls = Pathfinder::MultiLineString.new initial
  Pathfinder::Graph.from_multi_line_string mls
end

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