class Pathfinder
  class MultiLineString
    include Enumerable
    include Pathfinder::HausdorffDistanceMethods

    def initialize mls
      @mls = mls
    end

    def self.from_wkt wkt
      reader = WKTReader.new
      new reader.read wkt.to_s
    end

    def each
      if block_given?
        @mls.geometries.each { |g| yield Pathfinder::LineString.new g }
      else
        @mls.geometries.map { |g| Pathfinder::LineString.new g }.to_enum
      end
    end

    def length
      @mls.num_geometries
    end

    def last
      Pathfinder::LineString.new @mls.geometry_n(@mls.num_geometries - 1)
    end

    def to_s
      @mls.to_s
    end

    def jts_multi_line_string
      @mls
    end

    def jts_geometry
      @mls
    end

    def indexed_line
      # @indexed_line ||= LocationIndexedLine.new  LineSequencer.sequence self.jts_multi_line_string
      @indexed_line ||= LengthIndexedLine.new  LineSequencer.sequence self.jts_multi_line_string
    end

    def index pt
      indexed_line.index_of pt.coordinate
    end

    def endpoint_indexes
      self
        .map { |ls| [ls.first, ls.last] }
        .flatten
        .uniq
        .map { |pt| self.index pt }
    end


    def point_at index
      factory = Pathfinder.geometry_factory
      factory.create_point indexed_line.extract_point index
    end

    def envelope
      env = jts_multi_line_string.envelope_internal
      OpenStruct.new( min_x: env.min_x, min_y: env.min_y, max_x: env.max_x, max_y: env.max_y )
    end

    def self.break_line_string ls, indexes
      logger = Pathfinder.logger 'MultiLineString#break_line_string'
      factory = Pathfinder.geometry_factory
      # index = LocationIndexedLine.new ls.jts_line_string
      index = LengthIndexedLine.new ls.jts_line_string

      line_strings = indexes
        .each_cons(2)
        .map { |a,b|
          logger.debug "A,B: #{a} #{b}"
          index.extract_line a,b
        }.to_java(::LineString)
      line_strings.each do |ls|
        logger.debug "LS: #{ls}"
      end
      new factory.create_multi_line_string line_strings
    end

    def normalize!
      @mls.normalize
      self
    end
    # private

    def points
      points = []
      self.each { |ls| points += Array(ls) }
      points
    end

    def self.ls_from_mls mls
      # logger = Pathfinder.logger
      # logger.debug("%s.ls_from_mls" % [ name ]) { mls.to_s }
      sequenced = LineSequencer.sequence mls.jts_multi_line_string

      return Pathfinder::LineString.new sequenced if sequenced.instance_of? ::LineString

      points = []
      Pathfinder::MultiLineString.new(sequenced).each { |ls| points += Array(ls) }
      factory = Pathfinder.geometry_factory
      coordinates = points.uniq.map(&:coordinate).to_java Coordinate
      Pathfinder::LineString.new(factory.create_line_string coordinates)
    end
  end
end
