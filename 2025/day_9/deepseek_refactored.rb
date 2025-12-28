#!/usr/bin/env ruby

# Check if input file is provided
if ARGV.empty?
  puts "Usage: ruby theater_rectangles.rb input.txt"
  exit
end

# Read input file
input_file = ARGV[0]
red_tiles = File.readlines(input_file).map { |line| line.split(',').map(&:to_i) }

# Close the polygon loop
polygon = red_tiles + [red_tiles.first]

# Precompute all green tiles (edges and interior)
green_tiles = Set.new

# Add edges to green_tiles
polygon.each_cons(2) do |(x1, y1), (x2, y2)|
  if x1 == x2 # Vertical edge
    y_min, y_max = [y1, y2].minmax
    (y_min..y_max).each { |y| green_tiles.add([x1, y]) }
  else # Horizontal edge
    x_min, x_max = [x1, x2].minmax
    (x_min..x_max).each { |x| green_tiles.add([x, y1]) }
  end
end

# Determine the bounding box of the polygon
x_coords = polygon.map(&:first)
y_coords = polygon.map(&:last)
x_min, x_max = x_coords.minmax
y_min, y_max = y_coords.minmax

# Use ray-casting to find interior green tiles
(x_min..x_max).each do |x|
  (y_min..y_max).each do |y|
    next if green_tiles.include?([x, y]) # Skip if already marked as green

    # Ray-casting algorithm to check if (x, y) is inside the polygon
    n = polygon.size
    inside = false
    (0...n-1).each do |i|
      xi, yi = polygon[i]
      xj, yj = polygon[i+1]

      # Check if point is on the edge (should already be covered, but just in case)
      if (yi == yj && y == yi && x.between?([xi, xj].min, [xi, xj].max)) ||
         (xi == xj && x == xi && y.between?([yi, yj].min, [yi, yj].max))
        green_tiles.add([x, y])
        next
      end

      # Ray-casting intersection check
      if ((yi <= y && y < yj) || (yj <= y && y < yi)) &&
         (x < (xj - xi) * (y - yi).to_f / (yj - yi) + xi)
        inside = !inside
      end
    end

    green_tiles.add([x, y]) if inside
  end
end

# Find the largest valid rectangle
max_area = 0
red_tiles.each_with_index do |(x1, y1), i|
  red_tiles.each_with_index do |(x2, y2), j|
    next if i >= j # Avoid duplicate checks

    x_min, x_max = [x1, x2].minmax
    y_min, y_max = [y1, y2].minmax

    # Skip if the rectangle is outside the bounding box
    next if x_min < x_coords.min || x_max > x_coords.max ||
            y_min < y_coords.min || y_max > y_coords.max

    valid = true
    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        unless red_tiles.include?([x, y]) || green_tiles.include?([x, y])
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

puts "The largest rectangle area is: #{max_area}"

