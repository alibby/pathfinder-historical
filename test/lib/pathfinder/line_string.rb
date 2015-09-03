require_relative '../test_helper'

describe Pathfinder::LineString do
  before do
    @factory = GeometryFactory.new PrecisionModel.new, 4326
    @coordinates = [[0,0],[1,1],[2,2],[3,3]].map { |x,y| Coordinate.new x,y }.to_java(Coordinate)
    @segment = Pathfinder::LineString.new(@factory.createLineString @coordinates)
  end

  it "should return the first point" do
    @segment.first.must_equal @factory.createPoint @coordinates.first
  end

  it "should return the last point" do
    @segment.last.must_equal @factory.createPoint Array(@coordinates).last
  end
end

