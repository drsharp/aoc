#!/usr/bin/env ruby

# Advent of Code 2025 - Day 9, Part 2
#
# The key insight: The red tiles form vertices of a closed polygon.
# Green tiles exist on edges (between consecutive vertices) and inside the polygon.
# A rectangle is valid if:
#   1. Two opposite corners are red tiles (polygon vertices)
#   2. The entire rectangle is within the valid region (inside or on the polygon)
#
# To check rectangle containment:
#   1. All 4 corners must be valid (inside or on boundary)
#   2. No polygon edge can cross through the rectangle's interior

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!"
  exit
end

# Parse input - vertices in order define the polygon
vertices = []
File.readlines(ARGV.first, chomp: true).each do |line|
  x, y = line.split(",").map(&:to_i)
  vertices << [x, y]
end

n = vertices.length

# Build edges (consecutive vertex pairs, wrapping around)
edges = []
n.times do |i|
  edges << [vertices[i], vertices[(i + 1) % n]]
end

# Check if point is on a polygon edge (boundary)
def on_edge?(px, py, edges)
  edges.each do |(x1, y1), (x2, y2)|
    if y1 == y2 && py == y1  # Horizontal edge
      return true if px.between?([x1, x2].min, [x1, x2].max)
    elsif x1 == x2 && px == x1  # Vertical edge
      return true if py.between?([y1, y2].min, [y1, y2].max)
    end
  end
  false
end

# Ray casting algorithm for point-in-polygon (strictly inside)
def inside_polygon?(px, py, vertices)
  n = vertices.length
  inside = false
  j = n - 1

  n.times do |i|
    xi, yi = vertices[i]
    xj, yj = vertices[j]

    if ((yi > py) != (yj > py)) && (px < (xj - xi).to_f * (py - yi) / (yj - yi) + xi)
      inside = !inside
    end
    j = i
  end

  inside
end

# Point is valid if on boundary or inside the polygon
def valid_point?(px, py, vertices, edges)
  on_edge?(px, py, edges) || inside_polygon?(px, py, vertices)
end

# Check if a polygon edge crosses through the rectangle's interior
# (not just touching the boundary, but actually passing through)
def edge_crosses_interior?(edge, min_x, max_x, min_y, max_y)
  (x1, y1), (x2, y2) = edge

  if x1 == x2  # Vertical edge at x
    x = x1
    ey_min, ey_max = [y1, y2].minmax
    # Crosses if x is strictly inside rect's x-range AND y-ranges overlap in interior
    return x > min_x && x < max_x && ey_min < max_y && ey_max > min_y
  else  # Horizontal edge at y
    y = y1
    ex_min, ex_max = [x1, x2].minmax
    # Crosses if y is strictly inside rect's y-range AND x-ranges overlap in interior
    return y > min_y && y < max_y && ex_min < max_x && ex_max > min_x
  end
end

# Check if rectangle (with red corners at opposite diagonals) is entirely valid
def rectangle_valid?(x1, y1, x2, y2, vertices, edges)
  min_x, max_x = [x1, x2].minmax
  min_y, max_y = [y1, y2].minmax

  # Check all 4 corners are valid (inside or on boundary)
  corners = [[min_x, min_y], [min_x, max_y], [max_x, min_y], [max_x, max_y]]
  corners.each do |cx, cy|
    return false unless valid_point?(cx, cy, vertices, edges)
  end

  # Check no polygon edge crosses through the rectangle's interior
  # (If an edge crosses through, the rectangle spans both inside and outside the polygon)
  edges.each do |edge|
    return false if edge_crosses_interior?(edge, min_x, max_x, min_y, max_y)
  end

  true
end

# Find largest valid rectangle with red tiles at opposite corners
max_area = 0
best_pair = nil

vertices.each_with_index do |p1, i|
  vertices.each_with_index do |p2, j|
    next if j <= i  # Avoid duplicate pairs

    x1, y1 = p1
    x2, y2 = p2

    # Skip degenerate rectangles (same row or column = zero area)
    next if x1 == x2 || y1 == y2

    if rectangle_valid?(x1, y1, x2, y2, vertices, edges)
      width = (x2 - x1).abs + 1
      height = (y2 - y1).abs + 1
      area = width * height
      if area > max_area
        max_area = area
        best_pair = [p1, p2]
      end
    end
  end
end

puts "Solution for Day 9, Part 2: #{max_area}"
puts "Best rectangle corners: #{best_pair.inspect}" if best_pair
