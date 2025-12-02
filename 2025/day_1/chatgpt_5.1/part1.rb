#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code - Day 1: Secret Entrance (Part 1)
#
# This script:
# - Reads the input (list of rotations) from a local file named "input.txt".
# - Simulates the safe dial, which has positions 0..99.
# - The dial starts at position 50.
# - Each line in the input is a rotation: "L<number>" or "R<number>".
#   - L = turn left  (toward lower numbers)
#   - R = turn right (toward higher numbers)
# - The positions wrap around (circular dial), so we use modulo 100.
# - We count how many times, *after any rotation*, the dial points at 0.
# - Finally, we print: "Part 1 Solution: XXX", where XXX is the computed count.

# -----------------------------
# Helper: Read all input lines
# -----------------------------
def read_input
  path = File.join(__dir__, 'input.txt')

  unless File.exist?(path)
    abort "Input file not found: #{path}"
  end

  File.read(path).lines.map!(&:strip)
end

# -----------------------------
# Core logic for Part 1
# -----------------------------
def part1(rotations)
  # Dial positions range from 0 to 99 (100 total positions)
  modulo = 100

  # Initial dial position
  position = 50

  # Number of times the dial ends at exactly 0 after a rotation
  count_zero_hits = 0

  rotations.each do |line|
    # Skip completely empty lines (if any exist in the file)
    next if line.empty?

    # First character is direction: 'L' or 'R'
    direction = line[0]

    # The rest is the distance value (could be multiple digits)
    distance = line[1..].to_i

    # Normalize distance to [0, 99] since moving 100 steps is a full circle
    distance %= modulo

    # Update the position based on the direction:
    # - 'L' means move toward lower numbers: subtract the distance
    # - 'R' means move toward higher numbers: add the distance
    case direction
    when 'L'
      position = (position - distance) % modulo
    when 'R'
      position = (position + distance) % modulo
    else
      # If the input contains something unexpected, stop with an error.
      abort "Invalid direction '#{direction}' in line: #{line}"
    end

    # After applying this rotation, check if the dial points at 0.
    count_zero_hits += 1 if position.zero?
  end

  count_zero_hits
end

# -----------------------------
# Main program
# -----------------------------
if __FILE__ == $PROGRAM_NAME
  rotations = read_input
  answer_part1 = part1(rotations)

  puts "Part 1 Solution: #{answer_part1}"
end
