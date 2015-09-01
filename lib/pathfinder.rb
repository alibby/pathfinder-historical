
require_relative 'jruby-setup'

require_relative 'pathfinder/wkt_source'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'

class Pathfinder
  attr_reader :topology

  def initialize topology
    @topology = topology
  end

  def reduce
    true
  end
end