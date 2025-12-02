#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./solution.rb <inputfile>"
  exit
end

lines = File.readlines(ARGV.first, chomp: true)
left_side = []
right_side = []
lines.each do |line|
  left,right = line.split
  left_side << left.to_i
  right_side << right.to_i
end

# left_side.sort!
# right_side.sort!

print "Calculating similarity: "
similarity = 0
while left_number = left_side.shift do
  print "."
  similarity += left_number * right_side.count(left_number)
end

puts "\nSolution for Day 1: Total Similarity: #{similarity}"
