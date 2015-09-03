 
 class Pathfinder
  class LineString
    def initialize linestring
      @linestring = linestring
    end

    def first
      @linestring.points.first
    end

    def last
      @linestring.points.last
    end

    def to_s
      @linestring.to_s
    end

    def inspect
      to_s
    end
  end
end