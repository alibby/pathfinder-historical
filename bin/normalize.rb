#!/usr/bin/env ruby

require 'bundler/setup'

require_relative 'lib/pathfinder'

def usage_and_exit
  puts "USAGE: #{File.basename $0} path/to/wkt"
  exit 1
end

source_file = ARGV.first
usage_and_exit if source_file.nil?

begin
  source = Pathfinder::Source.for_resource source_file
  mls = source.read
  puts mls.jts_geometry
  mls.jts_geometry.normalize
  puts mls.jts_geometry
rescue Pathfinder::Source::UnknownSourceError => e
  puts "ERROR: Unknown source type #{source_file}"
  exit 3
rescue java.lang.NullPointerException => e
  usage_and_exit
rescue java.io.FileNotFoundException => e
  puts "ERROR: #{e}"
  exit 2
end
