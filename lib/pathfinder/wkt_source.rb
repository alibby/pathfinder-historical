
class Pathfinder
  class WKTSource
    def initialize filename
      @filename = filename
    end

    def read
      precision_model = PrecisionModel.new
      factory = GeometryFactory.new precision_model, 4326
      reader = WKTReader.new

      wkt_filereader = WKTFileReader.new @filename, reader
      geometry = wkt_filereader.read

      if geometry.length == 1
        geometry.first
      else
        factory.createMultiLineString Array geometry
      end
    end
  end
end
