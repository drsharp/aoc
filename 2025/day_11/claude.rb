#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!"
  exit
end

# Build adjacency list: for each node, which nodes feed INTO it
incoming = Hash.new { |h, k| h[k] = [] }

File.readlines(ARGV.first, chomp: true).each do |line|
  source, sinks = line.split(": ")
  sinks.split(" ").each do |sink|
    incoming[sink] << source
  end
end

# Memoized count of paths from node back to "you"
@memo = {}

def count_paths_to_you(node, incoming)
  return 1 if node == "you"
  return @memo[node] if @memo.key?(node)

  @memo[node] = incoming[node].sum { |pred| count_paths_to_you(pred, incoming) }
end

answer = count_paths_to_you("out", incoming)
puts "Solution for Day 11, Part 1: #{answer}"
