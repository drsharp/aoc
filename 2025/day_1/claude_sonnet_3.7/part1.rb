#!/usr/bin/env ruby

require 'net/http'

def solve_part1(rotations)
  # Start at position 50 as specified
  current_position = 50
  # Counter for how many times we land on 0
  zero_count = 0

  # Process each rotation instruction
  rotations.each do |rotation|
    direction = rotation[0] # First character is L or R
    distance = rotation[1..-1].to_i # Rest of the string is the distance

    # Apply the rotation based on direction
    if direction == 'L'
      # Left rotation decreases position
      current_position = (current_position - distance) % 100
    else # direction == 'R'
      # Right rotation increases position
      current_position = (current_position + distance) % 100
    end

    # Check if we're at position 0 after this rotation
    zero_count += 1 if current_position == 0
  end

  zero_count
end

# Read the input from the provided file
input = File.read('input.txt').strip.split("\n")

# Calculate the solution
result = solve_part1(input)

# Output the result
puts "Part 1 Solution: #{result}"
