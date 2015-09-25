
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

require 'logger'
require 'gippix'

class Pathfinder
  DISTANCE_THRESHOLD = (7.7659658124485205 / 10_000)
  @@options = nil

  attr_reader :graph, :reducers

  class NullLogger
    def debug(*); end
    def info(*); end
    def warn(*); end
    def error(*); end
    def fatal(*); end
  end

  def self.run
    logger = Pathfinder.logger
    logger.info "Pathfinder starting #{$$}"
    topology = Pathfinder::Topology.new(options.file).read
    logger.info "Read base network topology from #{options.file}"
    graph = Pathfinder::Graph.from_topology(topology)
    pathfinder = Pathfinder.new(graph)
    pathfinder.add_reducer Pathfinder::ParallelReducer
    pathfinder.add_reducer Pathfinder::SerialReducer
    pathfinder.add_reducer Pathfinder::TightLoopReducer
    pathfinder.add_reducer Pathfinder::FaceReducer unless options.without_face

    logger.info "Using reducers #{ pathfinder.reducers.map { |r| r.class.name }.join(', ')}"
    logger.info "Performing reduction"

    pathfinder.reduce
    logger.info "Reduction complete."

    unless options.quiet
      logger.info "Outputting new network"
      puts graph
    end
  end

  def self.options
    @@options
  end

  def self.configure options
    raise "Can't reconfigure pathfinder" if @@options
    @@options = options
  end

  def self.logger progname = 'pathfinder'
    if options.log
      logger = Logger.new options.log
      logger.sev_threshold = options.log_level
      logger.progname = progname
      logger
    else
      NullLogger.new
    end
  end


  def initialize graph
    @graph = graph
    @reducers = []
  end

  def add_reducer klass
    @reducers << klass.new(graph)
    self
  end

  def call
    return false if @reducers.length == 0

    loop do
      results = reducers.map { |reducer| reducer.reduce }
      # open('./graph.wkt', 'w') { |fh| fh.puts graph }
      break if results.all? { |s| s == false }
    end
  end

  def reduce
    call
  end
end