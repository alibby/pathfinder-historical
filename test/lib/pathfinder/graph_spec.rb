
require_relative '../../test_helper'

describe Pathfinder::Graph do
  describe '#equals?' do
    describe "from different MULTILINESTRINGs" do
      let(:g1) { graph_from_wkt("MULTILINESTRING((-1 -1, 1 1))") }
      # let(:g2) { graph_from_wkt("MULTILINESTRING((0 0, 5 5))") }
      let(:g2) { graph_from_wkt("MULTILINESTRING((0 0, 5 19))") }

      it "should not be equal?" do
        g1.equals?(g2).must_equal false
      end
    end

    describe "from identical MULTILINESTRINGs" do
      let(:g1) { graph_from_wkt("MULTILINESTRING((0 0, 1 1))") }
      let(:g2) { graph_from_wkt("MULTILINESTRING((0 0, 1 1))") }

      it "should be equal?" do
        g1.equals?(g2).must_equal true
      end
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