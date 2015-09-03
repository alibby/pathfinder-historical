
require_relative '../../test_helper'

describe Pathfinder::Graph do
  describe 'from_topology' do
    before do
      @topology = Minitest::Mock.new
      @topology.expect :segments, [[:a,:b], [:b, :c]]
      @graph = Pathfinder::Graph.from_topology @topology
    end

    it "should create" do
      puts @graph
    end
  end

  describe '#add_edge' do
    describe "when passed something with no first() method" do
      before do
        @graph = Pathfinder::Graph.new
        @invalid_segment = OpenStruct.new :last => :b
      end

      it "should raise an ArgumentError" do
        proc {
          @graph.add_edge @invalid_segment
        }.must_raise ArgumentError
      end
    end

    describe "when passed something with no last() method" do
      before do
        @graph = Pathfinder::Graph.new
        @invalid_segment = OpenStruct.new :first => :a
      end

      it "should raise an ArgumentError" do
        proc {
          @graph.add_edge @invalid_segment
        }.must_raise ArgumentError
      end
    end

    describe "should add an edge connected to first and last as it's vertices" do
      before do
        @graph = Pathfinder::Graph.new
        @segment = [:a, :b, :c]
        @graph.add_edge @segment
      end

      it "should add the segment to the graph" do
        @graph.edges.must_include @segment
      end

      it "should include vertex :a in the graph" do
        @graph.vertices.must_include :a
      end

      it "should include vertex :c in the graph" do
        @graph.vertices.must_include :c
      end
    end
  end
end