

class Pathfinder
  module HausdorffDistanceMethods
    def hausdorff_distance line_string
      DiscreteHausdorffDistance.distance self.jts_geometry, line_string.jts_geometry
    end

    def hausdorff_distance_meters line_string
      self.hausdorff_distance(line_string) * (Math::PI/180) * 6378137
    end
  end
end
