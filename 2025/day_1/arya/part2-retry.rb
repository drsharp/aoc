# Advent of Code Day 1 Solution
# This program calculates both parts:
# Part 1: Counts times dial points to 0 after each rotation
# Part 2: Counts all times dial points to 0 during rotations (including intermediate positions)

require 'open-uri'

# Function to apply rotation and count zero crossings during the movement
def process_rotation(current_position, rotation, count_zero_during)
  direction = rotation[0]
  distance = rotation[1..-1].to_i
  
  # Track each individual click during the rotation
  distance.times do |i|
    # Move one click in the specified direction
    if direction == 'R'
      current_position = (current_position + 1) % 100
    else # direction == 'L'
      current_position = (current_position - 1) % 100
    end
    
    # Count if we're at 0 during the rotation
    count_zero_during += 1 if current_position == 0
  end
  
  [current_position, count_zero_during]
end

# Main solution
def solve
  # Read input from local file
  input_data = File.read('input.txt')
  
  # Initialize variables
  current_position = 50
  part1_count = 0
  part2_count = 0
  
  # Process each rotation instruction
  input_data.strip.split("\n").each do |rotation|
    # Process the rotation step by step for Part 2 counting
    current_position, part2_count = process_rotation(current_position, rotation, part2_count)
    
    # Part 1: Count if we land on 0 after the full rotation
    part1_count += 1 if current_position == 0
  end
  
  puts "Part 1 Solution: #{part1_count}. Part 2 Solution: #{part2_count}"
end

# Run the solution
solve
