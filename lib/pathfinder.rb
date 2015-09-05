
require_relative 'jruby'

require_relative 'pathfinder/wkt_source'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'
require_relative 'pathfinder/line_string'
require_relative 'pathfinder/multi_line_string'
require_relative 'pathfinder/parallel_reducer'

class Pathfinder
  attr_reader :graph

  def initialize graph
    @graph = graph
  end

  def reduce
    parallel_reducer = ParallelReducer.new graph
    parallel_reducer.reduce
  end
end