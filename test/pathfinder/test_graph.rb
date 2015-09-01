
require_relative '../test_helper'

class TestGraph < Minitest::Test
  def setup
    @g = Pathfinder::Graph.new
  end

  def test_instantiation
    assert @g.instance_of?(Pathfinder::Graph)
  end
end

describe Pathfinder::Graph do
  before do
    @g = Pathfinder::Graph.new
  end

  it "should add an edge" do
    assert @g.add_edge :edge, :v1, :v2
  end
end