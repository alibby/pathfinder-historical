require_relative '../../test_helper'

require 'fileutils'

describe Pathfinder::FaceReducer do
  include CreateJumpOnFail

  describe "simple face" do
    before do
      @initial = graph_from_wkt_file 'face-001.wkt'
      @actual = graph_from_wkt_file 'face-001.wkt'
      @expected = graph_from_wkt_file'face-001-expected.wkt'
      @reducer = Pathfinder::FaceReducer.new @actual
    end

    it "should reduce face" do
      @reducer.reduce.must_equal true
      @actual.equals?(@expected).must_equal true
    end
  end
end