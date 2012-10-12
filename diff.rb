#!/usr/bin/env ruby

# Use to find which links in one CSV file are not in another, and vice versa
#
# Usage:
#
#   ./diff.rb <old_filename> <new_filename>
#
# If you want to get hold of an old version of a file, you can use the command:
#
#   git show <branch-or-sha>:data/index/filename.csv > old_filename.csv

unless ARGV.length == 2
  puts "Expected two arguments: given #{ARGV.length}"
  exit(1)
end

$LOAD_PATH.unshift "lib" unless $LOAD_PATH.include? "lib"

require "recommended_links/parser"

old_filename, new_filename = ARGV

old_links, new_links = ARGV.map { |filename|
  RecommendedLinks::Parser.new(filename).links
}

puts "Found #{old_links.length} links in old file"
puts "Found #{new_links.length} links in new file"
puts

removed_links = old_links.map(&:url) - new_links.map(&:url)

puts "Links in #{old_filename} but not in #{new_filename}:"
if removed_links.empty?
  puts "No links to be removed"
else
  puts removed_links.sort
  puts "(#{removed_links.length} links)"
end

