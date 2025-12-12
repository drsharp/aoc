#!/usr/bin/env ruby

# Advent of Code Day 7 - Part 1 Solution

# CLAUDE 4

def solve_tachyon_manifold(input)
  grid = input.strip.split("\n")
  rows = grid.length
  cols = grid[0].length

  # Find starting position
  start_col = nil
  grid.each_with_index do |row, r|
    row.each_char.with_index do |char, c|
      if char == 'S'
        start_col = c
        break
      end
    end
    break if start_col
  end

  # Track active beams: [row, col]
  beams = [[0, start_col]]
  split_count = 0

  while !beams.empty?
    new_beams = []

    beams.each do |row, col|
      # Move beam down one row
      new_row = row + 1

      # Check if beam exits the grid
      next if new_row >= rows

      # Check what's at the new position
      if grid[new_row][col] == '^'
        # Hit a splitter - count the split and create two new beams
        split_count += 1

        # Create left beam
        if col > 0
          new_beams << [new_row, col - 1]
        end

        # Create right beam
        if col < cols - 1
          new_beams << [new_row, col + 1]
        end
      else
        # Continue moving down
        new_beams << [new_row, col]
      end
    end

    beams = new_beams
  end

  split_count
end

# Test with the example
example = <<~INPUT
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
INPUT

puts solve_tachyon_manifold(example)
