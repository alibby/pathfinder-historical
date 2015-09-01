
class Pathfinder
  class Topology
    def initialize filename
      raise TypeError.new("filename can't be nil") if filename.nil?
      raise IOError.new("#{filename} does not exist") unless File.exists?(filename)
      raise IOError.new ("can't read #{filename}") unless File.readable?(filename)
      @filename = filename
    end

    def read
      pm = PrecisionModel.new
      factory = GeometryFactory.new pm, 4326
      wkt_reader = WKTReader.new factory
      wkt_file_reader = WKTFileReader.new @filename, wkt_reader
      @geometry = wkt_file_reader.read.first
      self
    end

    def to_s
      @geometry.to_s
    end
  end
end