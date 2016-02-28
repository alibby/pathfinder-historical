
$CLASSPATH << Dir[File.join(File.dirname(__FILE__),'..','jars','*.jar')]

require "java"

java_import com.vividsolutions.jts.geom.Coordinate
java_import com.vividsolutions.jts.geom.GeometryFactory
java_import com.vividsolutions.jts.geom.Geometry
java_import com.vividsolutions.jts.geom.GeometryCollection
java_import com.vividsolutions.jts.geom.impl.CoordinateArraySequence
java_import com.vividsolutions.jts.geom.IntersectionMatrix
java_import com.vividsolutions.jts.geom.LineString
java_import com.vividsolutions.jts.geom.LineSegment
java_import com.vividsolutions.jts.geom.MultiLineString
java_import com.vividsolutions.jts.geom.MultiPoint
java_import com.vividsolutions.jts.geom.Point
java_import com.vividsolutions.jts.geom.PrecisionModel
java_import com.vividsolutions.jts.io.WKTReader
java_import com.vividsolutions.jts.io.WKTFileReader
java_import com.vividsolutions.jts.noding.BasicSegmentString
java_import com.vividsolutions.jts.noding.IteratedNoder
java_import com.vividsolutions.jts.noding.NodedSegmentString
java_import com.vividsolutions.jts.noding.SegmentString
java_import com.vividsolutions.jts.noding.SinglePassNoder

java_import com.vividsolutions.jts.operation.linemerge.LineSequencer

java_import com.vividsolutions.jts.linearref.LocationIndexedLine
java_import com.vividsolutions.jts.linearref.LengthIndexedLine
java_import com.vividsolutions.jts.algorithm.Angle

java_import com.vividsolutions.jts.algorithm.distance.DiscreteHausdorffDistance

java_import com.vividsolutions.jts.util.AssertionFailedException

java_import java.io.FileReader
java_import java.util.ArrayList


class ::LineString
  def points
    0.upto(num_points - 1).map do |i|
      self.get_point_n(i)
    end
  end

  def closest_point(pt)
    puts "closest_pt(#{pt})"
    point_distances = self.points[1..-1].map { |other_pt| [ other_pt, pt.distance(other_pt) ] }
    point_distances.each do |pt,dist|
      puts "%s %.24f" % [ pt, dist]
    end
    point_distances.sort { |a,b| b.last <=> a.last }.first.first
  end
end


class MultiLineString
  def geometries
    0.upto(num_geometries - 1).map do |i|
      self.get_geometry_n(i)
    end
  end
end
