
require_relative '../../test_helper'

describe Pathfinder::SerialReducer do
  include CreateJumpOnFail

  describe "a single linestring" do
    let(:initial) { graph_from_wkt_file('serial-001.wkt') }
    let(:actual) { graph_from_wkt_file('serial-001.wkt') }
    let(:expected) { graph_from_wkt_file('serial-001-expected.wkt') }
    let(:reducer) { Pathfinder::SerialReducer.new actual }

    it "should perform no reductions" do
      actual.edges.length.must_equal 1
      reducer.reduce.must_equal false
      actual.edges.length.must_equal 1
      actual.equals?(expected).must_equal true
    end
  end

  describe "badly sequenced reduction" do
    let(:initial) { graph_from_wkt_file('serial-002.wkt') }
    let(:actual) { graph_from_wkt_file('serial-002.wkt') }
    let(:expected) { graph_from_wkt_file('serial-002-expected.wkt') }
    let(:reducer) { Pathfinder::SerialReducer.new actual }

    it "produce a single linestring LINESTRING (0 0, 0 1, 1 1)" do
      actual.edges.length.must_equal 2
      reducer.reduce.must_equal true
      actual.edges.length.must_equal 1
      actual.equals?(expected).must_equal true
    end
  end

  # describe "something" do
  #   let(:initial) { graph_from_wkt_file 'serial-003.wkt' }
  #   let(:actual) { graph_from_wkt_file 'serial-003.wkt' }
  #   let(:reducer) { Pathfinder::SerialReducer.new actual }
  #   let(:expected) { graph_from_wkt_file 'serial-003-expected.wkt' }
  #   it "should not suck" do
  #     reducer.reduce.must_equal true
  #     puts actual
  #     puts expected
  #     puts actual.equals?(expected)
  #     actual.equals?(expected).must_equal true
  #   end
  # end


end