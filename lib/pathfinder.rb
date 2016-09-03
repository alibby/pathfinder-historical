
require_relative 'jruby'

require_relative 'pathfinder/source'
require_relative 'pathfinder/source/wkt_file'
require_relative 'pathfinder/source/gpx_directory'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/hausdorff_distance_methods'
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
  DISTANCE_THRESHOLD = 30 # meters
  PRECISION_SCALE = 1_000_000
  @@options = nil

  attr_accessor :graph
  attr_accessor :parallel_reducer, :serial_reducer, :tightloop_reducer, :face_reducer

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
    mls = Pathfinder::MultiLineString.from_wkt(File.read(options.file))
    logger.info "Read base network from #{options.file}"
    graph = Pathfinder::Graph.from_multi_line_string(mls)
    pathfinder = Pathfinder.new(graph)

    # logger.info "Using reducers #{ pathfinder.reducers.map { |r| r.class.name }.join(', ')}"
    logger.info "Reduction starting"

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

  def self.precision_model
    @@precision_model ||= PrecisionModel.new PRECISION_SCALE
  end

  def self.geometry_factory
    @@factory ||= GeometryFactory.new precision_model, 4326
  end

  def initialize graph
    @graph = graph
    @parallel_reducer = Pathfinder::ParallelReducer.new graph
    @serial_reducer = Pathfinder::SerialReducer.new graph
    @tightloop_reducer = Pathfinder::TightLoopReducer.new graph
    @face_reducer =  Pathfinder::FaceReducer.new graph
  end

  # def add_reducer klass
  #   @reducers << klass.new(graph)
  #   self
  # end

  def serial_reduce
    modified = false
    while serial_reducer.reduce == true do
      modified = true
    end
    modified
  end


  def call
    reducers = [
      proc { serial_reduce },
      proc { parallel_reducer.reduce },
      proc { serial_reduce },
      proc { face_reducer.reduce },
      proc { serial_reduce },
      proc { tightloop_reducer.reduce }
    ]

    loop do
      break unless reducers.any?(&:call)
    end

    loop do
      break unless reducers.any?(&:call)
    end
  end

  def reduce
    call
  end
end
