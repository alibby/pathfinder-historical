class Pathfinder
  class Reducer
    private

    attr_accessor :graph

    public

    def initialize graph
      @graph = graph
      @modified = false
    end

    private

    def modified! flag = true
      @modified = flag
    end

    def modified?
      @modified
    end

    def remove_edge line_string
      logger = Pathfinder.logger "#{self.class.name}#remove_edge"

      if ! graph.contains_edge? line_string
        logger.debug "Graph does not contain #{line_string}"
        logger.debug "LineString class: #{line_string.class.name}"
        graph.dump_to_file
        exit 1
      end

      if ! graph.remove_edge line_string
        logger.error "Edge remove failed: #{line_string}"
      else
        logger.debug "Edge Removal: #{line_string}"
        @modified = true
      end

      @modified
    end

    def add_edge line_string
      logger = Pathfinder.logger

      if line_string.first == line_string.last
        logger.warn("#{self.class.name}#add_edge") { "Adding looped edge: #{line_string}" }
      end

      if ! graph.add_edge line_string
        logger.error(self.class.name) { "Edge addition failed: #{line_string}" }
      else
        logger.debug(self.class.name) { "Edge Add: #{line_string}" }
        @modified = true
      end

      @modified
    end

    def too_far_apart? pair
      logger = Pathfinder.logger
      edge1, edge2 = pair
      distance = edge1.hausdorff_distance_meters(edge2)

      if distance > Pathfinder::DISTANCE_THRESHOLD
        logger.debug(self.class.name) { "Longest linestrings too far apart: #{distance}" }
        logger.debug(self.class.name) { pair.first.to_s }
        logger.debug(self.class.name) { pair.last.to_s }
        true
      else
        false
      end
    end

    def distance2meters(dist)
      dist * (Math::PI/180) * 6378137
    end
  end
end