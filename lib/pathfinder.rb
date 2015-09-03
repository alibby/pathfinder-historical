
require_relative 'jruby'

require_relative 'pathfinder/wkt_source'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'
require_relative 'pathfinder/line_string'

class Pathfinder
  attr_reader :graph

  def initialize topology
    @graph = graph
  end

  def reduce
    true
  end
end