#!/usr/bin/env ruby

# Read the input from command line argument or default to 'input.txt'
filename = ARGV[0] || 'input.txt'

unless File.exist?(filename)
  puts "Error: File '#{filename}' not found"
  exit 1
end

input = File.read(filename).strip

# Parse the grid
grid = input.lines.map(&:chomp).map(&:chars)
height = grid.length
width = grid[0].length

# Find the starting position (S)
start_row = 0
start_col = 0
grid.each_with_index do |row, r|
  row.each_with_index do |cell, c|
    if cell == 'S'
      start_row = r
      start_col = c
      break
    end
  end
end

# Track beams and splits
# Each beam is represented as [row, col, direction]
# Direction: :down, :left, :right, :up
beams = [[start_row, start_col, :down]]
split_count = 0

# Keep track of beam states we've already processed to avoid infinite loops
seen_states = Set.new

while !beams.empty?
  row, col, direction = beams.shift

  # Create a unique state identifier
  state = [row, col, direction]
  next if seen_states.include?(state)
  seen_states.add(state)

  # Move in the current direction
  case direction
  when :down
    row += 1
  when :up
    row -= 1
  when :left
    col -= 1
  when :right
    col += 1
  end

  # Check if we're out of bounds
  next if row < 0 || row >= height || col < 0 || col >= width

  # Check what's at this position
  cell = grid[row][col]

  if cell == '^'
    # We hit a splitter - count it and create two new beams
    split_count += 1

    # Create beams going left and right from the splitter
    beams << [row, col, :left]
    beams << [row, col, :right]
  elsif cell == '.' || cell == 'S'
    # Empty space or start - continue in same direction
    beams << [row, col, direction]
  end
end

puts "Part 1 Solution: #{split_count}"
