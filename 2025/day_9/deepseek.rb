#!/usr/bin/env ruby

# Check if input file is provided
if ARGV.empty?
  puts "Usage: ruby part2.rb input.txt"
  exit
end

# Read input file
input_file = ARGV[0]
red_tiles = File.readlines(input_file).map { |line| line.split(',').map(&:to_i) }

# Close the polygon loop
polygon = red_tiles + [red_tiles.first]

# Check if a point (x, y) is on an edge between two points
def on_edge?(x, y, edge)
  x1, y1 = edge[0]
  x2, y2 = edge[1]

  if y1 == y2 # Horizontal edge
    y == y1 && x.between?([x1, x2].min, [x1, x2].max)
  elsif x1 == x2 # Vertical edge
    x == x1 && y.between?([y1, y2].min, [y1, y2].max)
  else
    false # Edges are only horizontal or vertical in this problem
  end
end

# Ray-casting algorithm to check if a point is inside the polygon
def point_in_polygon?(x, y, polygon)
  n = polygon.size
  inside = false

  (0...n-1).each do |i|
    x1, y1 = polygon[i]
    x2, y2 = polygon[i+1]

    # Check if point is on the edge
    if on_edge?(x, y, [polygon[i], polygon[i+1]])
      return true
    end

    # Ray-casting intersection check
    if ((y1 <= y && y < y2) || (y2 <= y && y < y1)) &&
       (x < (x2 - x1) * (y - y1).to_f / (y2 - y1) + x1)
      inside = !inside
    end
  end

  inside
end

# Check if a tile is green (on edge or inside polygon)
def green?(x, y, polygon)
  # Check edges
  polygon.each_cons(2) do |edge|
    return true if on_edge?(x, y, edge)
  end

  # Check inside
  point_in_polygon?(x, y, polygon)
end

# Find the largest valid rectangle
def largest_rectangle(red_tiles, polygon)
  max_area = 0

  red_tiles.each_with_index do |(x1, y1), i|
    red_tiles.each_with_index do |(x2, y2), j|
      next if i == j # Skip same tile

      x_min, x_max = [x1, x2].minmax
      y_min, y_max = [y1, y2].minmax

      valid = true
      (x_min..x_max).each do |x|
        (y_min..y_max).each do |y|
          unless red_tiles.include?([x, y]) || green?(x, y, polygon)
            valid = false
            break
          end
        end
        break unless valid
      end

      if valid
        area = (x_max - x_min + 1) * (y_max - y_min + 1)
        max_area = [max_area, area].max
      end
    end
  end

  max_area
end

# Calculate and print the result
max_area = largest_rectangle(red_tiles, polygon)
puts "The largest rectangle area is: #{max_area}"
