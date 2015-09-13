
require_relative 'jruby'

require_relative 'pathfinder/source'
require_relative 'pathfinder/source/wkt_file'
require_relative 'pathfinder/source/gpx_directory'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'
require_relative 'pathfinder/line_string'
require_relative 'pathfinder/multi_line_string'
require_relative 'pathfinder/reducer'
require_relative 'pathfinder/parallel_reducer'
require_relative 'pathfinder/serial_reducer'
require_relative 'pathfinder/face_reducer'
require_relative 'pathfinder/face'
require_relative 'pathfinder/tight_loop_reducer'

require 'gippix'

class Pathfinder
  DISTANCE_THRESHOLD = (7.7659658124485205 / 10_000)

  attr_reader :graph, :reducers

  def initialize graph
    @graph = graph
    @reducers = []

  end

  def add_reducer klass
    @reducers << klass.new(graph)
    self
  end

  def reduce
    return false if @reducers.length == 0

    loop do
      results = reducers.map { |reducer| reducer.reduce }
      break if results.all? { |s| s == false }
    end
  end
end