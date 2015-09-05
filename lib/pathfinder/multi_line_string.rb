class Pathfinder
  class MultiLineString
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

    def to_s
      @mls.to_s
    end
  end
end