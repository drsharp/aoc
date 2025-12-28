#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

class Point
  attr_reader :id, :x, :y

  def initialize(id, x,y)
    @id = id
    @x = x
    @y = y
  end
end

class Area
  def initialize(point_a, point_b)
    @point_a = point_a
    @point_b = point_b
  end

  def size
    width = (@point_a.x - @point_b.x).abs + 1
    height = (@point_a.y - @point_b.y).abs + 1
    width * height
  end
end

points = []
File.readlines(ARGV.first, chomp: true).each_with_index do |row, r_idx|
  x,y = row.split(",").map(&:to_i)
  points << Point.new(r_idx, x, y)
end

biggest_area = 0
distances_between = []
points.each do |point_a|
  points.each do |point_b|
    next if point_b.id <= point_a.id
    area = Area.new(point_a, point_b).size
    biggest_area = [biggest_area, area].max
  end
end

puts "Solution for Day 9, Part 1: #{biggest_area}"

# ---------------------------------------------------
# --- Day 9: Movie Theater ---

# You slide down the firepole in the corner of the playground and land in the North Pole base movie theater!

# The movie theater has a big tile floor with an interesting pattern. Elves here are redecorating the theater by switching out some of the square tiles in the big grid they form. Some of the tiles are red; the Elves would like to find the largest rectangle that uses red tiles for two of its opposite corners. They even have a list of where the red tiles are located in the grid (your puzzle input).

# For example:

# 7,1
# 11,1
# 11,7
# 9,7
# 9,5
# 2,5
# 2,3
# 7,3

# Showing red tiles as # and other tiles as ., the above arrangement of red tiles would look like this:

# ..............
# .......#...#..
# ..............
# ..#....#......
# ..............
# ..#......#....
# ..............
# .........#.#..
# ..............

# You can choose any two red tiles as the opposite corners of your rectangle; your goal is to find the largest rectangle possible.

# For example, you could make a rectangle (shown as O) with an area of 24 between 2,5 and 9,7:

# ..............
# .......#...#..
# ..............
# ..#....#......
# ..............
# ..OOOOOOOO....
# ..OOOOOOOO....
# ..OOOOOOOO.#..
# ..............

# Or, you could make a rectangle with area 35 between 7,1 and 11,7:

# ..............
# .......OOOOO..
# .......OOOOO..
# ..#....OOOOO..
# .......OOOOO..
# ..#....OOOOO..
# .......OOOOO..
# .......OOOOO..
# ..............

# You could even make a thin rectangle with an area of only 6 between 7,3 and 2,3:

# ..............
# .......#...#..
# ..............
# ..OOOOOO......
# ..............
# ..#......#....
# ..............
# .........#.#..
# ..............

# Ultimately, the largest rectangle you can make in this example has area 50. One way to do this is between 2,5 and 11,1:

# ..............
# ..OOOOOOOOOO..
# ..OOOOOOOOOO..
# ..OOOOOOOOOO..
# ..OOOOOOOOOO..
# ..OOOOOOOOOO..
# ..............
# .........#.#..
# ..............

# Using two red tiles as opposite corners, what is the largest area of any rectangle you can make?
