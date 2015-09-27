
class Pathfinder
  class Source
    class WKTFile
      def initialize filename
        @filename = filename
      end

      def read
        factory = Pathfinder.geometry_factory
        reader = WKTReader.new

        wkt_filereader = WKTFileReader.new @filename, reader
        geometry = wkt_filereader.read

        if geometry.length == 1
          Pathfinder::MultiLineString.new geometry.first
        else
          Pathfinder::MultiLineString.new factory.createMultiLineString Array geometry
        end
      end
    end
  end
end
