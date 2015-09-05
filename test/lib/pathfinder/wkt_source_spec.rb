
require_relative '../../test_helper'

describe Pathfinder::WKTSource do
  subject { Pathfinder::WKTSource.new('data/wkt/simple.wkt').read }

  describe "read from WKT with multile linestrings" do
    it "reads the the correct number of LINSTRING entries into a MULTILINESTRING" do
      assert_instance_of Pathfinder::MultiLineString, subject
      assert subject.length == 2
    end
  end

  describe "read from WKT with a single MULTILINESTRING" do
    subject { Pathfinder::WKTSource.new('data/wkt/simple_noded.wkt').read }

    it "reads a single MULTILINESTRING with the correct number of entries" do
      assert_instance_of Pathfinder::MultiLineString, subject
      assert subject.length > 2
    end
  end
end