 
 class Pathfinder
  class LineString
    include Enumerable

    def initialize linestring
      @linestring = linestring
    end

    def == ls
      @linestring == ls
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

    def hausdorff_distance line_string
      DiscreteHausdorffDistance.distance self.jts_line_string, line_string.jts_line_string
    end

    def indexed_line
      @indexed_line ||= LengthIndexedLine.new  LineSequencer.sequence self.jts_line_string
    end

    def index pt
      indexed_line.index_of pt.coordinate
    end

    def point_at index
      factory = GeometryFactory.new PrecisionModel.new, 4326
      factory.create_point(indexed_line.extract_point(index))
    end

    # protected

    def jts_line_string
      @linestring
    end

    # public

    def closest_point_to pt
      distance_and_point = map { |line_pt|
        [ line_pt.distance(pt), line_pt ]
      }.sort { |a,b|
        a.first <=> b.first
      }.first

      distance_and_point.last
    end

    def self.average(ls1, ls2)
      ls1, ls2 = ls2, ls1 if ls2.length > ls1.length

      coordinates = ls1
        .map { |pt1|      [ pt1, ls2.closest_point_to(pt1) ] }
        .map { |pt1, pt2| [ pt1.coordinate, pt2.coordinate   ] }
        .map { |c1, c2|   LineSegment.mid_point(c1, c2)        }
        .to_java(Coordinate)

      pm = PrecisionModel.new
      factory = GeometryFactory.new pm, 4326
      Pathfinder::LineString.new factory.create_line_string coordinates
    end
  end
end