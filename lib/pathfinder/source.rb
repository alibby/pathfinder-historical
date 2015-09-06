class Pathfinder
  class Source
    class UnknownSourceError < StandardError
    end

    def self.class_for_type type
      {
        "wkt": Pathfinder::Source::WKTFile,
        "gpxd": Pathfinder::Source::GPXDirectory
      }.fetch type.to_sym

    rescue KeyError => e
      raise UnknownSourceError.new type
    end

    def self.is_resource_gpx_directory? resource
      return false unless File.directory? resource

      !! Dir["#{resource}/*"].first { |fn|
        File.file?(fn) and File.extname(fn)[1..-1].to_s.downcase == 'gpx' 
      }
    end

    def self.for_resource resource
      if File.extname(resource).to_s.length > 1
        klass = self.class_for_type File.extname(resource)[1..-1]
        klass.new resource
      elsif self.is_resource_gpx_directory? resource
        Pathfinder::Source::GPXDirectory.new resource
      else
        raise UnknownSourceError.new resource
      end
    end
  end
end