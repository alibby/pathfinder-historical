
require_relative '../test_helper'

describe Pathfinder::Topology do
  describe "new with nil filename" do
    it "should raise a type error" do
      proc {
        Pathfinder::Topology.new nil
      }.must_raise TypeError
    end
  end

  describe "new with non-existant file" do
    it "should raise an IOErorr" do
      proc {
        Pathfinder::Topology.new "file/doesnot/exist.wkt"
      }.must_raise IOError
    end
  end

  describe "new with a non-readable file" do
    before do
      @filename = 'not-readable.wkt'
      FileUtils.touch @filename
      FileUtils.chmod 'a-rwx', @filename
    end

    after do
      FileUtils.rm @filename
    end

    it "should raise an IOError" do
      proc {
        Pathfinder::Topology.new @filename
      }.must_raise IOError
    end
  end

  describe  "read" do
    before do
      @filename = 'data/wkt/simple_noded.wkt'
      @topology = Pathfinder::Topology.new @filename
      @read_result = @topology.read
    end

    it "should return a reference to self" do
      @read_result.must_be_same_as @topology
    end

    it "should read a single MULTILINESTRING from a wkt" do
      @topology.to_s.must_match /^MULTILINESTRING/
    end
  end
end