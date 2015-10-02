require_relative '../../test_helper'

describe Pathfinder::MultiLineString do
  describe 'from_wkt' do

    let(:mls) {
      wkt = File.read(File.join(File.dirname(__FILE__), '..','..', 'data','wkt','face-001.wkt'))
      Pathfinder::MultiLineString.from_wkt wkt
    }

    it "should have points" do
      mls.length.must_be :>, 0
    end
  end

  describe '#to_s' do
    let(:jts_mls) {
      m = Minitest::Mock.new
      m.expect :to_s, 'MULTILINESTRING ()'
    }

    let(:pf_mls) { Pathfinder::MultiLineString.new jts_mls }

    it "should create WKT for the MLS" do
      pf_mls.to_s.must_equal "MULTILINESTRING ()"
    end

    it "should produce the WKT by calling the unerlying JTS #to_s method" do
      pf_mls.to_s
      jts_mls.verify.must_equal true
    end
  end

  describe  '#length' do
    before do
      @jts_mls = Minitest::Mock.new
      @jts_mls.expect(:num_geometries, 0)
      @pf_mls = Pathfinder::MultiLineString.new @jts_mls
    end

    it "#length gets the number of geometries from it's internal MutliLineString" do
      @pf_mls.length.must_equal 0
      @jts_mls.verify.must_equal true
    end
  end

  describe '#each' do
    describe "when called with a block" do
      before do
        @jts_mls = Minitest::Mock.new
        @jts_mls.expect :geometries, %w/a b c/
        @pf_mls = Pathfinder::MultiLineString.new @jts_mls
      end

      it "should yield %w/a b c/ wrapped in Pathfinder::LineStrings" do
        index = 0
        values = %w/a b c/
        @pf_mls.each do |linestring|
          linestring.must_be_instance_of Pathfinder::LineString
          linestring.to_s.must_equal values[index]
          index += 1
        end
      end
    end

    describe "when called without a block" do
      before do
        @jts_mls = Minitest::Mock.new
        @jts_mls.expect :geometries, %w/a b c/
        @pf_mls = Pathfinder::MultiLineString.new @jts_mls
        @enum = @pf_mls.each
      end

      it "should return an enumerator" do
        @enum.must_be_instance_of Enumerator
      end

      it "should contain %w/a b c/ wrapped in Pathfinder::LineStrings" do
        %w/a b c/.each do |letter|
          next_val = @enum.next
          next_val.must_be_instance_of Pathfinder::LineString
          next_val.to_s.must_equal letter
        end
      end
    end
  end
end