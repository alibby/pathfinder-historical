class Pathfinder
  class Source
    class GPXDirectory
      def initialize folder
        @folder = folder
      end

      def read
        pm = PrecisionModel.new
        factory = GeometryFactory.new pm, 4326

        linestrings = gpx_files.map do |gpx_file|
          points = gpx_to_linestring gpx_file
          coordinates = points.map { |pt| Coordinate.new pt.lon, pt.lat }
          factory.create_line_string coordinates.to_java(Coordinate)
        end

        MultiLineString.new factory.create_multi_line_string linestrings.to_java(::LineString)
      end

      private

      def gpx_files
        Dir["#{folder}/*"].select { |fn|
          File.extname(fn)[1..-1].to_s.downcase == 'gpx'
        }
      end

      def gpx_to_linestring gpx_file
        gpx = Gippix::Gpx.new gpx_file
        gpx.parse.points
      end

      attr_accessor :folder
    end
  end
end