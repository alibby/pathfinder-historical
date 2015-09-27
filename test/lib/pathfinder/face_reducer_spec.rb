require_relative '../../test_helper'

require 'fileutils'

describe Pathfinder::FaceReducer do
  include CreateJumpOnFail

  describe "simple face" do
    let(:initial) { @initial ||= graph_from_wkt_file 'face-001.wkt' }
    let(:actual)  { @actual  ||= graph_from_wkt_file 'face-001.wkt' }
    let(:expected) { @expected ||= graph_from_wkt_file'face-001-expected.wkt' }
    let(:reducer) { @reducer ||= Pathfinder::FaceReducer.new actual }

    it "should reduce face" do
      reducer.reduce.must_equal true
      actual.equals?(expected).must_equal true
    end
  end
end