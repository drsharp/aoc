#!/usr/bin/env ruby

# Advent of Code Day 7 - Part 1 Solution

# DEEPSEEK 3

def count_splits(grid)
  # Find starting position 'S'
  start_y = grid.index { |row| row.include?('S') }
  start_x = grid[start_y].index('S') if start_y
  return 0 unless start_x && start_y

  # Replace 'S' with '|' since it's a downward beam
  grid[start_y][start_x] = '|'

  # Directions: [dx, dy]
  directions = {
    right: [1, 0],
    left: [-1, 0],
    down: [0, 1],
    up: [0, -1]
  }

  # Initialize beams: [x, y, direction]
  beams = [[start_x, start_y, :down]]
  split_count = 0
  visited = Hash.new { |h, k| h[k] = Set.new }

  while beams.any?
    new_beams = []

    beams.each do |x, y, dir|
      # Skip if out of bounds
      next if y < 0 || y >= grid.size || x < 0 || x >= grid[0].size

      # Skip if we've already processed this position+direction
      key = [x, y]
      next if visited[key].include?(dir)
      visited[key].add(dir)

      cell = grid[y][x]

      case cell
      when '^'
        split_count += 1
        # Split into left and right beams
        new_beams << [x - 1, y, :left]
        new_beams << [x + 1, y, :right]
      when '|'
        # Continue in same direction if moving vertically
        if dir == :down || dir == :up
          dx, dy = directions[dir]
          new_beams << [x + dx, y + dy, dir]
        else
          # Split into up and down beams
          split_count += 1
          new_beams << [x, y - 1, :up]
          new_beams << [x, y + 1, :down]
        end
      when '.', 'S'
        # Continue in same direction
        dx, dy = directions[dir]
        new_beams << [x + dx, y + dy, dir]
      end
    end

    puts "new_beams=#{new_beams}, split_count=#{split_count}"
    beams = new_beams
  end

  split_count
end

# Main execution
begin
  grid = File.readlines('input.txt').map(&:chomp)
  solution = count_splits(grid)
  puts "Part 1 Solution: #{solution}"
rescue Errno::ENOENT
  puts "Error: Could not find input.txt file."
end
