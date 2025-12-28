#!/usr/bin/env ruby

require 'pry'

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

# an edge has two points
# then you from each point, scan right and see if it hits another point. And if so, find the farthest right and that's the end
# the area is then edge * scan


class Point
  attr_reader :x, :y

  def initialize(x,y)
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

class HorizEdge # start and end are on the same row
  attr_reader :start_idx, :end_idx, :row_idx

  def initialize(start_idx, end_idx, row_idx)
    @start_idx = start_idx
    @end_idx = end_idx
    @row_idx = row_idx
  end

  def to_s
    "#{start_idx} -> #{end_idx} on Row #{row_idx}"
  end
end

class VertEdge # start and end are on the same column
  attr_reader :start_idx, :end_idx, :col_idx

  def initialize(start_idx, end_idx, col_idx)
    @start_idx = start_idx
    @end_idx = end_idx
    @col_idx = col_idx
  end

  def to_s
    "#{start_idx} -> #{end_idx} on Col #{col_idx}"
  end
end

class Corner
  def initialize(corner_point, other_vert, other_horiz)
    @corner_point = corner_point
    @other_vert = other_vert
    @other_horiz = other_horiz
  end
end


# rows_with_points = [1,7,5,3]. Don't need to be sorted
# then go through each, say row 7: and find all points _on_ row 7 and group them into edges
# find y_es that match 7 and pull their indices
# Horiz:
# 7,1 on row 1
# 11,9 on row 7



x_es = []
y_es = []
File.readlines(ARGV.first, chomp: true).each_with_index do |row, r_idx|
  x,y = row.split(",").map(&:to_i)
  x_es << x
  y_es << y
end

rows_with_points = Set.new(y_es).sort
cols_with_points = Set.new(x_es).sort

# row_edges = {}
# col_edges = {}

row_edges = []
col_edges = []

rows_with_points.each do |pointed_row|
  col_vals = []
  y_es.each_with_index do |value, col_idx|
    col_vals << x_es[col_idx] if value == pointed_row
  end

  col_vals.sort.combination(2).map { |a, b| [a, b].sort }.each do |start_x, end_x|
    row_edges << HorizEdge.new(start_x, end_x, pointed_row)
  end
end

cols_with_points.each do |pointed_col|
  row_vals = []
  x_es.each_with_index do |value, row_idx|
    row_vals << y_es[row_idx] if value == pointed_col
  end

  # col_edges[pointed_col] = row_vals.sort.combination(2).map { |a, b| [a, b].sort }
  row_vals.sort.combination(2).map { |a, b| [a, b].sort }.each do |start_y, end_y|
    col_edges << VertEdge.new(start_y, end_y, pointed_col)
  end
end

puts "Row Edges: #{row_edges}"
puts "Col Edges: #{col_edges}"

# find corners
# ok, now I want to say: if a row edge and col edge share The starting point point, calculate the area
# how do they share a point?

# so I have:
# 1: list of


# The secret is:
# x------x
# | ---
# x
# upper right is one
# X
# |
# x ----- x
# is another

# so find all where the edge start

@biggest_area = 0
row_edges.each do |row_edge|
  # if there is a col_edge that has the start point and row
  col_edges.each do |col_edge|
# row_edge: #<HorizEdge:0x000000011d872558 @start_idx=7, @end_idx=11, @row_idx=1>
# col_edge: #<VertEdge:0x000000011d871590 @start_idx=1, @end_idx=3, @col_idx=7>
    if row_edge.start_idx == col_edge.col_idx
      # area is:
      # length of row_edge * height of col edge

      horiz = (row_edge.end_idx - row_edge.start_idx).abs + 1
      vert = (col_edge.end_idx - col_edge.start_idx).abs + 1
      area = horiz*vert
      puts "For REdge: #{row_edge}, CEdge: #{col_edge} => Area: #{area}. horiz=#{horiz}, vert=#{vert}"
      @biggest_area = [@biggest_area, area].max
    end
  end
end


puts "Solution for Day 9, Part 2: #{@biggest_area}"

# ---------------------------------------------------
# --- Part Two ---

# The Elves just remembered: they can only switch out tiles that are red or green. So, your rectangle can only include red or green tiles.

# In your list, every red tile is connected to the red tile before and after it by a straight line of green tiles. The list wraps, so the first red tile is also connected to the last red tile. Tiles that are adjacent in your list will always be on either the same row or the same column.

# Using the same example as before, the tiles marked X would be green:

# ..............
# .......#XXX#..
# .......X...X..
# ..#XXXX#...X..
# ..X........X..
# ..#XXXXXX#.X..
# .........X.X..
# .........#X#..
# ..............

# In addition, all of the tiles inside this loop of red and green tiles are also green. So, in this example, these are the green tiles:

# ..............
# .......#XXX#..
# .......XXXXX..
# ..#XXXX#XXXX..
# ..XXXXXXXXXX..
# ..#XXXXXX#XX..
# .........XXX..
# .........#X#..
# ..............

# The remaining tiles are never red nor green.

# The rectangle you choose still must have red tiles in opposite corners, but any other tiles it includes must now be red or green. This significantly limits your options.

# For example, you could make a rectangle out of red and green tiles with an area of 15 between 7,3 and 11,1:

# ..............
# .......OOOOO..
# .......OOOOO..
# ..#XXXXOOOOO..
# ..XXXXXXXXXX..
# ..#XXXXXX#XX..
# .........XXX..
# .........#X#..
# ..............

# Or, you could make a thin rectangle with an area of 3 between 9,7 and 9,5:

# ..............
# .......#XXX#..
# .......XXXXX..
# ..#XXXX#XXXX..
# ..XXXXXXXXXX..
# ..#XXXXXXOXX..
# .........OXX..
# .........OX#..
# ..............

# The largest rectangle you can make in this example using only red and green tiles has area 24. One way to do this is between 9,5 and 2,3:

# ..............
# .......#XXX#..
# .......XXXXX..
# ..OOOOOOOOXX..
# ..OOOOOOOOXX..
# ..OOOOOOOOXX..
# .........XXX..
# .........#X#..
# ..............

# Using two red tiles as opposite corners, what is the largest area of any rectangle you can make using only red and green tiles?
