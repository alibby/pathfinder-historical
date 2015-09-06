require_relative '../../test_helper'

describe Pathfinder::Source do
  describe "class_for_type" do
    it "should return Pathfinder::Source::WKT for 'wkt'" do
      Pathfinder::Source.class_for_type('wkt')
        .must_equal Pathfinder::Source::WKTFile
    end

    it "should return Pathfinder::Source::GPXDirectory for 'gpxd'" do
      Pathfinder::Source.class_for_type('gpxd')
        .must_equal Pathfinder::Source::GPXDirectory
    end
  end

  describe "for_resource" do
    describe "for a wkt file" do
      before do
        @wkt_filename = 'test-file.wkt'
        FileUtils.touch @wkt_filename
      end

      after do
        FileUtils.rm @wkt_filename
      end

      it "should return a Pathfinder::Source::WKTFile" do
        Pathfinder::Source.for_resource(@wkt_filename)
          .must_be_instance_of Pathfinder::Source::WKTFile
      end
    end

    describe "for a gpx directory" do
      before do
        @directory = 'test_gpx_folder'
        FileUtils.mkdir @directory
        FileUtils.touch "#{@directory}/one.gpx"
      end

      after do
        FileUtils.rm_rf @directory
      end

      it "should return a Pathfinder::Source::GPXDirectory" do
        Pathfinder::Source.for_resource(@directory)
          .must_be_instance_of Pathfinder::Source::GPXDirectory
      end
    end
  end
end