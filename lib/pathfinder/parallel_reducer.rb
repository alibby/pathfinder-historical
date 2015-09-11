
class Pathfinder
  class ParallelReducer
    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
      @excluded_pairs = Set.new
      @modified = false
    end

    def reduce
      @excluded_pairs.clear
      @modified = false
      while(! (pair = find_an_edge_pair).nil?) do
        edge1, edge2 = pair

        dist = edge1.hausdorff_distance edge2

        if too_far_apart? pair
          @excluded_pairs << pair
          next
        end
        @modified = true
        new_edge = average_edges edge1, edge2
        graph.remove_edge edge1
        graph.remove_edge edge2
        graph.add_edge new_edge
      end

      @modified
    end

    private

    def find_an_edge_pair
      graph.vertices
        .map { |v| graph.parallel_edges v }
        .reject { |potential_pair| pair_excluded? potential_pair }
        .find { |potential_pair| potential_pair.length > 1 }
    end

    def pair_excluded? pair
      @excluded_pairs.include? pair
    end

    def too_far_apart? pair
      edge1, edge2 = pair
      edge1.hausdorff_distance(edge2) > Pathfinder::DISTANCE_THRESHOLD
    end

    def average_edges edge1, edge2
      edge1, edge2 = edge2, edge1 if edge2.length > edge1.length

      coordinates = edge1
        .map { |pt1|      [ pt1, edge2.closest_point_to(pt1) ] }
        .map { |pt1, pt2| [ pt1.coordinate, pt2.coordinate   ] }
        .map { |c1, c2|   LineSegment.mid_point(c1, c2)        }
        .to_java(Coordinate)

      pm = PrecisionModel.new
      factory = GeometryFactory.new pm, 4326
      Pathfinder::LineString.new factory.create_line_string coordinates
    end
  end
end