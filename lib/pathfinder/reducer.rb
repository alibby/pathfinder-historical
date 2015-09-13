class Pathfinder
  class Reducer
    def too_far_apart? pair
      edge1, edge2 = pair
      edge1.hausdorff_distance(edge2) > Pathfinder::DISTANCE_THRESHOLD
    end
  end
end