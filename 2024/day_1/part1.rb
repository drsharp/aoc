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

left_side.sort!
right_side.sort!

distance = 0
left_side.count.times do |index|
  distance += (left_side[index] - right_side[index]).abs
end


puts "Solution for Day 1: Total Distance: #{distance}"
