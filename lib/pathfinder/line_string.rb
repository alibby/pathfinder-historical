 
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
  end
end