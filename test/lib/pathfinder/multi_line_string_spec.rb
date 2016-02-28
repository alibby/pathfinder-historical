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

    # describe '#break_line_string' do
    #   let(:line_string) {
    #     x = geom_from_wkt 'LINESTRING (-75.43788 40.109658, -75.437838 40.1096495, -75.437731 40.109633, -75.4376485 40.109665, -75.437619 40.109662, -75.4375575 40.1096645, -75.437471 40.10967, -75.437378 40.1096245, -75.4373255 40.1096215, -75.437258 40.109625) ' 
    #     Pathfinder::LineString.new x
    #   }
    #   let(:indexes) { [0.0, 0.0003445352185367185, 0.0006467178418499554, 0.0006631721945041522] }

    #   it "should not suck" do
    #     x = Pathfinder::MultiLineString.break_line_string line_string, indexes
    #     pm = Pathfinder.precision_model
    #     indexes.each do |index|
    #       puts "#{index} #{line_string.point_at(index)} #{pm.make_precise(index)}"
    #     end

    #     x.each do |ls|
    #       puts ls
    #     end
    #   end
    # end
  end
end