
require_relative 'jruby'

require_relative 'pathfinder/source'
require_relative 'pathfinder/source/wkt_file'
require_relative 'pathfinder/source/gpx_directory'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'
require_relative 'pathfinder/line_string'
require_relative 'pathfinder/multi_line_string'
require_relative 'pathfinder/parallel_reducer'
require_relative 'pathfinder/serial_reducer'

require 'gippix'

class Pathfinder
  attr_reader :graph

  def initialize graph
    @graph = graph
  end

  def reduce
    parallel_reducer = Pathfinder::ParallelReducer.new graph
    parallel_reducer.reduce
    serial_reducer = Pathfinder::SerialReducer.new graph
    serial_reducer.reduce
  end
end