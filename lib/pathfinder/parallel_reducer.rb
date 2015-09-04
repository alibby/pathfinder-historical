
class ParallelReducer
  private

  attr_accessor :graph

  public

  def initialize graph
    @graph = graph
  end

  def reduce
    pair = graph.find_an_edge_pair

    return unless pair

    edge1, edge2 = pair

    # java_import "com.vividsolutions.jts.algorithm.distance.DiscreteHausdorffDistance"
    # p DiscreteHausdorffDistance

    new_edge = average_edges edge1, edge2
    graph.remove_edge edge1
    graph.remove_edge edge2
    graph.add_edge new_edge
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

  def parallel_edge_pair
    pari

    graph.parallel_edges(v).first
  end
end