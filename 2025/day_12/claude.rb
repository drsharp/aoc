#!/usr/bin/env ruby

require 'set'

def parse_input(filename)
  content = File.read(filename)
  sections = content.split("\n\n")

  shapes = {}
  regions = []

  sections.each do |section|
    lines = section.lines.map(&:chomp)
    first_line = lines.first

    if first_line =~ /^(\d+):$/
      # This is a shape definition
      shape_idx = $1.to_i
      shapes[shape_idx] = lines[1..].reject(&:empty?)
    elsif first_line =~ /^(\d+)x(\d+):/
      # This section contains regions
      lines.each do |line|
        next if line.empty?
        if line =~ /^(\d+)x(\d+):\s*(.*)$/
          width = $1.to_i
          height = $2.to_i
          counts = $3.split.map(&:to_i)
          regions << { width: width, height: height, counts: counts }
        end
      end
    end
  end

  [shapes, regions]
end

def shape_to_coords(lines)
  coords = []
  lines.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      coords << [x, y] if char == '#'
    end
  end
  coords
end

def normalize(coords)
  return [] if coords.empty?
  min_x = coords.map(&:first).min
  min_y = coords.map(&:last).min
  coords.map { |x, y| [x - min_x, y - min_y] }.sort
end

def rotate_90(coords)
  # Rotate 90 degrees clockwise: (x, y) -> (y, -x)
  normalize(coords.map { |x, y| [-y, x] })
end

def flip_horizontal(coords)
  normalize(coords.map { |x, y| [-x, y] })
end

def all_orientations(coords)
  orientations = Set.new
  current = normalize(coords)

  4.times do
    orientations << current
    orientations << flip_horizontal(current)
    current = rotate_90(current)
  end

  orientations.to_a
end

def can_place(grid, coords, ox, oy, width, height)
  coords.all? do |x, y|
    nx, ny = ox + x, oy + y
    nx >= 0 && nx < width && ny >= 0 && ny < height && !grid[ny][nx]
  end
end

def place(grid, coords, ox, oy)
  coords.each { |x, y| grid[oy + y][ox + x] = true }
end

def unplace(grid, coords, ox, oy)
  coords.each { |x, y| grid[oy + y][ox + x] = false }
end

def solve(grid, pieces, width, height)
  return true if pieces.empty?

  piece = pieces.first
  remaining = pieces[1..]

  (0...height).each do |y|
    (0...width).each do |x|
      piece.each do |orientation|
        if can_place(grid, orientation, x, y, width, height)
          place(grid, orientation, x, y)
          return true if solve(grid, remaining, width, height)
          unplace(grid, orientation, x, y)
        end
      end
    end
  end

  false
end

def can_fit_region(shapes, region)
  width = region[:width]
  height = region[:height]
  counts = region[:counts]

  # Build list of pieces to place (each with all orientations)
  pieces = []
  counts.each_with_index do |count, shape_idx|
    next unless shapes[shape_idx]
    coords = shape_to_coords(shapes[shape_idx])
    orientations = all_orientations(coords)
    count.times { pieces << orientations }
  end

  return true if pieces.empty?

  # Check if total cells fit
  total_cells = pieces.sum { |p| p.first.size }
  return false if total_cells > width * height

  # Sort pieces by number of orientations (fewer first - more constrained)
  # and by size (larger first)
  pieces.sort_by! { |p| [p.size, -p.first.size] }

  grid = Array.new(height) { Array.new(width, false) }
  solve(grid, pieces, width, height)
end

shapes, regions = parse_input(ARGV[0] || 'input.txt')

count = 0
regions.each_with_index do |region, i|
  if can_fit_region(shapes, region)
    count += 1
    puts "Region #{i + 1}: CAN fit"
  else
    puts "Region #{i + 1}: CANNOT fit"
  end
end

puts "\nTotal regions that can fit: #{count}"
