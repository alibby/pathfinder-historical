 
 class Pathfinder
  class LineString
    include Enumerable

    def initialize linestring
      @linestring = linestring
    end

    def first
      @linestring.points.first
    end

    def last
      @linestring.points.last
    end

    def each
      if block_given?
        @linestring.points.each do |pt|
          yield pt
        end
      else
        @linestring.points.each
      end
    end

    def coordinates
      @linestring.coordinates
    end

    def length
      @linestring.points.length
    end

    def to_s
      @linestring.to_s
    end

    def inspect
      to_s
    end

    def closest_point_to pt
      distance_and_point = map { |line_pt|
        [ line_pt.distance(pt), line_pt ]
      }.sort { |a,b|
        a.first <=> b.first
      }.first

      distance_and_point.last
    end
  end
end