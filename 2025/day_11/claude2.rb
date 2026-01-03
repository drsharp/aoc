#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!"
  exit
end

# Build adjacency list: for each node, which nodes it connects TO (outgoing)
outgoing = Hash.new { |h, k| h[k] = [] }

File.readlines(ARGV.first, chomp: true).each do |line|
  source, sinks = line.split(": ")
  sinks.split(" ").each do |sink|
    outgoing[source] << sink
  end
end

# Memoized count of paths from `from` to `to`
def count_paths(from, to, outgoing, memo)
  return 1 if from == to
  key = [from, to]
  return memo[key] if memo.key?(key)

  memo[key] = outgoing[from].sum { |succ| count_paths(succ, to, outgoing, memo) }
end

# Count paths that visit both dac and fft (in either order)
# Order 1: svr -> dac -> fft -> out
# Order 2: svr -> fft -> dac -> out

memo = {}

order1 = count_paths("svr", "dac", outgoing, memo) *
         count_paths("dac", "fft", outgoing, memo) *
         count_paths("fft", "out", outgoing, memo)

order2 = count_paths("svr", "fft", outgoing, memo) *
         count_paths("fft", "dac", outgoing, memo) *
         count_paths("dac", "out", outgoing, memo)

answer = order1 + order2
puts "Solution for Day 11, Part 2: #{answer}"
