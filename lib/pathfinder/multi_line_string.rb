class Pathfinder
  class MultiLineString
    include Enumerable

    def initialize mls
      @mls = mls
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

    def hausdorff_distance line_string
      DiscreteHausdorffDistance.distance self.jts_multi_line_string, line_string.jts_multi_line_string
    end

    def indexed_line
      @indexed_line ||= LengthIndexedLine.new  LineSequencer.sequence self.jts_multi_line_string
    end

    def index pt
      indexed_line.index_of pt.coordinate
    end

    def point_at index
      factory = GeometryFactory.new PrecisionModel.new, 4326
      factory.create_point indexed_line.extract_point index
    end

    def self.break_line_string ls, indexes
      factory = GeometryFactory.new PrecisionModel.new, 4326
      index = LengthIndexedLine.new ls.jts_line_string

      line_strings = indexes.each_cons(2).map { |a,b| index.extract_line a,b }.to_java(::LineString)
      new factory.create_multi_line_string line_strings
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
      factory = GeometryFactory.new PrecisionModel.new, 4326
      coordinates = points.uniq.map(&:coordinate).to_java Coordinate
      Pathfinder::LineString.new(factory.create_line_string coordinates)
    end
  end
end