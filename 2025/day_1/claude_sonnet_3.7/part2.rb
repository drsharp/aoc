#!/usr/bin/env ruby

require 'net/http'

def solve_dial_puzzle(rotations)
  # Start at position 50 as specified
  current_position = 50
  
  # Counters for both parts
  part1_count = 0  # Counts zeros at the end of rotations
  part2_count = 0  # Counts all zeros (during and at end of rotations)

  rotations.each do |rotation|
    direction = rotation[0] # First character is L or R
    distance = rotation[1..-1].to_i # Rest of the string is the distance

    # For Part 2, we need to check every position the dial passes through
    if direction == 'L'
      # For each click of the dial when moving left
      distance.times do
        current_position = (current_position - 1) % 100
        part2_count += 1 if current_position == 0
      end
    else # direction == 'R'
      # For each click of the dial when moving right
      distance.times do
        current_position = (current_position + 1) % 100
        part2_count += 1 if current_position == 0
      end
    end

    # Check if we're at position 0 after this rotation (Part 1)
    if current_position == 0
      part1_count += 1
      # Note: We don't need to count this again for Part 2, as the last click 
      # was already counted in the loop above
    end
  end

  [part1_count, part2_count]
end

# Read the input from the provided file
input = File.read('input.txt').strip.split("\n")

# Calculate the solutions
part1_result, part2_result = solve_dial_puzzle(input)

# Output the results
puts "Part 1 Solution: #{part1_result}. Part 2 Solution: #{part2_result}"
