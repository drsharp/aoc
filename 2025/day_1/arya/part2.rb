# Advent of Code Day 1 Solution
# This program calculates both parts: 
# Part 1: Counts times dial points to 0 after each rotation
# Part 2: Counts all times dial points to 0 during rotations (including intermediate positions)

require 'open-uri'

# Function to calculate the number of times 0 is crossed during a rotation
def count_zero_crossings(start_pos, direction, distance)
  count = 0
  
  if direction == 'R'
    # Moving right - check if we cross 0 going forward
    end_pos = (start_pos + distance) % 100
    # Count how many full circles we complete + if we pass through 0
    full_circles = (start_pos + distance) / 100
    count = full_circles
    # Check if we cross from 99 to 0 during rotation
    if (start_pos <= 99) && (end_pos < start_pos)
      count += 1
    end
  else # direction == 'L'
    # Moving left - check if we cross 0 going backward
    end_pos = (start_pos - distance) % 100
    # Count how many full circles we complete going backward + if we pass through 0
    full_circles = (distance - start_pos - 1) / 100 + 1
    count = full_circles
    # Check if we cross from 0 to 99 during rotation
    if (start_pos >= 0) && (end_pos > start_pos)
      count += 1
    end
  end
  
  count
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
    direction = rotation[0]
    distance = rotation[1..-1].to_i
    
    # Part 2: Count zero crossings during the rotation
    part2_count += count_zero_crossings(current_position, direction, distance)
    
    # Apply rotation to get new position
    if direction == 'R'
      current_position = (current_position + distance) % 100
    else
      current_position = (current_position - distance) % 100
    end
    
    # Part 1: Count if we land on 0 after rotation
    part1_count += 1 if current_position == 0
  end
  
  puts "Part 1 Solution: #{part1_count}. Part 2 Solution: #{part2_count}"
end

# Run the solution
solve
