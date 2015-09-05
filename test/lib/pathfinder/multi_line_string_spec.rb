require_relative '../../test_helper'

describe Pathfinder::MultiLineString do
  describe  '#to_s' do
    before do
      @jts_mls = Minitest::Mock.new
      @jts_mls.expect(:to_s, 'MULTILINESTRING ()')
      @pf_mls = Pathfinder::MultiLineString.new @jts_mls
    end

    it "#to_s wraps the internal MultiLineString" do
      @pf_mls.to_s.must_equal 'MULTILINESTRING ()'
      @jts_mls.verify.must_equal true
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