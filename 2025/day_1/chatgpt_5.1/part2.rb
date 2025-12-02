#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code - Day 1: Secret Entrance
#
# This script:
# - Reads the input (list of rotations) from a local file named "input.txt".
# - Simulates the safe dial, which has positions 0..99.
# - The dial starts at position 50.
#
# Part 1:
#   Count the number of times the dial is pointing at 0 *after* a rotation.
#
# Part 2 (method 0x434C49434B):
#   Count the number of times any *click* causes the dial to point at 0,
#   including intermediate positions during a rotation and the final position.
#
# The script outputs one line:
#   Part 1 Solution: XXX. Part 2 Solution: YYY

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
# Core solver for both parts
# -----------------------------
def solve(rotations)
  modulo = 100

  # Initial dial position
  position = 50

  # Part 1: count how many rotations end with the dial at 0
  part1_count = 0

  # Part 2: count how many individual clicks land on 0
  part2_count = 0

  rotations.each do |line|
    next if line.empty?

    direction = line[0]
    # Distance can be large; keep the full value for Part 2
    distance = line[1..].to_i

    # -------------------------
    # Part 2: count zero clicks
    # -------------------------
    # We want to count how many k in [1, distance] satisfy:
    #   - For R: (position + k) % 100 == 0
    #   - For L: (position - k) % 100 == 0
    #
    # This is solved arithmetically without simulating every click:
    #
    #   For R:
    #     position + k ≡ 0 (mod 100)
    #     k ≡ -position ≡ (100 - position) (mod 100)
    #
    #   For L:
    #     position - k ≡ 0 (mod 100)
    #     k ≡ position (mod 100)
    #
    # For each case, the first positive solution k0 is:
    #   - R: k0 = (100 - position) % 100, but if that is 0 we need k0 = 100
    #   - L: k0 = position if position != 0; otherwise k0 = 100
    #
    # Then we count how many values k = k0 + 100 * n lie within 1..distance.

    case direction
    when 'R'
      # First positive k where we land on 0 moving right
      k0 = (modulo - position) % modulo
      k0 = modulo if k0.zero? # if already at 0, next time is after a full circle
    when 'L'
      # First positive k where we land on 0 moving left
      k0 = position.zero? ? modulo : position
    else
      abort "Invalid direction '#{direction}' in line: #{line}"
    end

    if distance >= k0
      # 1 for the first hit at k0, plus any further hits every 100 clicks
      part2_count += 1 + (distance - k0) / modulo
    end

    # -------------------------
    # Update position for both parts
    # -------------------------
    # For the final position, we can reduce distance modulo 100
    # since only the final position is relevant (not the path).
    distance_mod = distance % modulo

    case direction
    when 'R'
      position = (position + distance_mod) % modulo
    when 'L'
      position = (position - distance_mod) % modulo
    end

    # Part 1: check if we end this rotation at 0
    part1_count += 1 if position.zero?
  end

  [part1_count, part2_count]
end

# -----------------------------
# Main program
# -----------------------------
if __FILE__ == $PROGRAM_NAME
  rotations = read_input
  part1, part2 = solve(rotations)

  puts "Part 1 Solution: #{part1}. Part 2 Solution: #{part2}"
end
