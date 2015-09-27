
require_relative '../lib/pathfinder'

require 'minitest/spec'
require 'minitest/autorun'
require 'fileutils'
require 'ostruct'
require 'erb'

Pathfinder.configure OpenStruct.new

def graph_from_wkt wkt
  rdr = WKTReader.new(Pathfinder.geometry_factory)
  initial = rdr.read(wkt)
  mls = Pathfinder::MultiLineString.new initial
  Pathfinder::Graph.from_multi_line_string mls
end

def graph_from_wkt_file file
  graph_from_wkt File.read File.join(File.dirname(__FILE__), 'data','wkt', file)
end

def jump_filename
  File.join(File.dirname(__FILE__), '..', 'tmp', self.name.gsub(/\s+/, '_')) + '.jmp'
end

module CreateJumpOnFail
  def before_teardown
    super
    if self.failures.length > 0
      @failures ||= []
      @failures << self.name
      JumpResultBuilder.new(self).build if self.failures.length > 0
    end
  end
end

class JumpResultBuilder
  private

  attr_reader :test

  TEMPLATE = File.join(File.dirname(__FILE__), 'jump_template.jmp')

  public

  def initialize test
    @test = test
  end

  def build
    FileUtils.mkdir_p destination_folder
    File.write initial_file, test.instance_variable_get(:@initial).to_s
    File.write expected_file, test.instance_variable_get(:@expected).to_s
    File.write actual_file, test.instance_variable_get(:@actual).to_s

    output = ERB.new(File.read TEMPLATE).result(binding)
    File.write jump_file, output
  end

  def bounding_box
    return @bounding_box if @bounding_box
    initial = test.instance_variable_get(:@initial).to_multi_line_string
    @bounding_box = initial.envelope
  end

  def bb; bounding_box; end

  def jump_file; destination_file("test.jmp"); end
  def initial_file; destination_file 'initial.wkt'; end
  def expected_file; destination_file 'expected.wkt'; end
  def actual_file; destination_file 'actual.wkt'; end
  def destination_file name
    File.join destination_folder, name
  end

  def destination_folder
    File.join( File.dirname(__FILE__), '..', 'tmp', test.name.gsub(/\s+/, '_') )
  end
end
