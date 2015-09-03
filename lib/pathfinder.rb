
require_relative 'jruby'

require_relative 'pathfinder/wkt_source'
require_relative 'pathfinder/noder'
require_relative 'pathfinder/graph'
require_relative 'pathfinder/topology'
require_relative 'pathfinder/line_string'

class Pathfinder
  attr_reader :graph

  def initialize graph
    @graph = graph
  end

  def reduce
    graph.vertices.each do |v|
      pe = graph.parallel_edges v
      puts pe if pe
    end
  end
end