# Advent of Code Day 1 Part 1 Solution
# This program calculates how many times the dial points to 0 during the rotation sequence

require 'open-uri'

# Function to apply a rotation to the dial and check if it lands on 0
def apply_rotation(current_position, rotation, count_zero)
  direction = rotation[0]  # First character: 'L' or 'R'
  distance = rotation[1..-1].to_i  # Rest of the string converted to integer
  
  # Apply rotation based on direction
  if direction == 'R'
    # Rotate right (increase number)
    current_position = (current_position + distance) % 100
  else # direction == 'L'
    # Rotate left (decrease number) - equivalent to adding negative distance modulo 100
    current_position = (current_position - distance) % 100
  end
  
  # Count if we landed on 0
  count_zero += 1 if current_position == 0
  
  [current_position, count_zero]
end

# Main solution
def solve_part1
  # Download the input data from Advent of Code
  input_url = 'https://adventofcode.com/2025/day/1/input'
  
  # Note: In a real scenario, you'd need to include your session cookie
  # For now, we'll assume the input is saved locally as 'input.txt'
  # input_data = URI.open(input_url).read
  
  # Read from local file instead
  input_data = File.read('input.txt')
  
  # Start with dial at position 50
  current_position = 50
  count_zero = 0
  
  # Process each rotation instruction
  input_data.strip.split("\n").each do |rotation|
    current_position, count_zero = apply_rotation(current_position, rotation, count_zero)
  end
  
  puts "Part 1 Solution: #{count_zero}"
end

# Run the solution
solve_part1
