
module Pathfinder
  class Topology
    def initialize filename
      @filename = filename
    end

    def read
        open @filename
    #   pm = PrecisionModel.new
    #   factory = GeometryFactory.new pm, 4326
    #   WKTReader
    end
  end
end