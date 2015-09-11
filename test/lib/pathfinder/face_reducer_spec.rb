
require_relative '../../test_helper'

describe Pathfinder::FaceReducer do
  describe  '#angle_to_right' do
    before do
      pm = PrecisionModel.new
      factory = GeometryFactory.new pm, 4326
      P = -> (x,y) { factory.createPoint Coordinate.new x,y }
      O = OpenStruct

      @cases = [
        O.new(angle: 0.0, coordinates: [ [5, 0], [0, 0], [5, 0] ].map { |x,y| P.call x, y }),
        O.new(angle: 354.28940686250036, coordinates: [ [0, 0], [1, 10], [1, 0] ].map { |x,y| P.call x, y }),
        O.new(angle: 5.710593137499643, coordinates: [ [10, 1], [0, 0], [10, 0] ].map { |x,y| P.call x, y }),
      ]
    end

    it "should calculate the number of degrees to the right" do
      @cases.each do |tc|
        angle = Pathfinder::FaceReducer.angle_to_right(*tc.coordinates)
        angle.must_equal tc.angle
      end
    end
  end
end