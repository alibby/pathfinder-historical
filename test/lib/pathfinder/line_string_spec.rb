require_relative '../../test_helper'

describe Pathfinder::LineString do
  before do
    @factory = GeometryFactory.new PrecisionModel.new, 4326
    @coordinates = [[0,0],[1,1],[2,2],[3,3]].map { |x,y| Coordinate.new x,y }.to_java(Coordinate)
    @segment = Pathfinder::LineString.new(@factory.createLineString @coordinates)
  end

  describe "#first" do
    it "should return the first point" do
      @segment.first.must_equal @factory.createPoint @coordinates.first
    end
  end

  describe '#last' do
    it "should return the last point" do
      @segment.last.must_equal @factory.createPoint Array(@coordinates).last
    end
  end

  describe "#to_s" do
    it "should return valid WKT" do
      @segment.to_s.must_match /^LINESTRING/
    end
  end

  describe "#inspect" do
    it "should return valid WKT" do
      @segment.to_s.must_match /^LINESTRING/
    end
  end

  describe "average" do
    before do
      
    end
    it "should average lines" do

    end
  end

end

