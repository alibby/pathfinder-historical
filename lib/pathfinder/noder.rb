class Pathfinder
  class Noder
    attr_reader :mls

    def initialize(mls)
      @mls = mls
    end

    private

    def pm
      Pathfinder.precision_model
    end

    def noder
      @noder ||= IteratedNoder.new pm

      @noder
    end

    def factory
      Pathfinder.geometry_factory
    end

    public

    def node
      collection = ArrayList.new()

      mls.each do |linestring|
        collection.add NodedSegmentString.new linestring.coordinates, nil
      end

      noder.computeNodes collection

      noded = noder.get_noded_substrings

      linestrings = noded.map { |line|
        factory.createLineString line.get_coordinates
      }.to_java(::LineString)


      Pathfinder::MultiLineString.new factory.createMultiLineString linestrings
    end
  end
end