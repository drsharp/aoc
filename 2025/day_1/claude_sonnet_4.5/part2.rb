#!/usr/bin/env ruby
require 'net/http'
require 'uri'

# Fetch the input data from the Advent of Code website
def fetch_input
  url = 'https://adventofcode.com/2025/day/1/input'
  uri = URI.parse(url)
  
  # Note: This requires a valid session cookie to work
  # For now, let's try to read from a local file if the download fails
  begin
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      response.body
    else
      # Fallback to local file if web request fails
      File.read('input.txt')
    end
  rescue
    # If both fail, try reading from local file
    File.read('input.txt')
  end
end

# Solve Part 1: Count how many times the dial points to 0 after rotations
def solve_part1(rotations)
  position = 50
  zero_count = 0
  
  rotations.each do |rotation|
    direction = rotation[0]
    distance = rotation[1..-1].to_i
    
    if direction == 'L'
      position = (position - distance) % 100
    elsif direction == 'R'
      position = (position + distance) % 100
    end
    
    # Count only if we END on 0
    zero_count += 1 if position == 0
  end
  
  zero_count
end

# Solve Part 2: Count how many times the dial points to 0 during AND after rotations
def solve_part2(rotations)
  position = 50
  zero_count = 0
  
  rotations.each do |rotation|
    direction = rotation[0]
    distance = rotation[1..-1].to_i
    
    # Calculate how many times we pass through 0 during this rotation
    if direction == 'L'
      # Moving left (decreasing): count how many times we cross 0
      # We cross 0 when going from positive to negative in modulo space
      new_position = (position - distance) % 100
      
      # Calculate how many complete wraps around 0 we make
      # Each time we go below 0, we wrap to 99, 98, etc.
      if distance >= position
        # We will cross 0 at least once
        # Number of times = how many times we subtract 100 to get to new_position
        zero_count += (distance - position) / 100 + 1
      end
    elsif direction == 'R'
      # Moving right (increasing): count how many times we cross 0
      new_position = (position + distance) % 100
      
      # Calculate how many complete wraps around through 0
      # We cross 0 when going from 99 to 0
      if position + distance >= 100
        # Number of times = how many times we add 100 to wrap around
        zero_count += (position + distance) / 100
      end
    end
    
    position = new_position
  end
  
  zero_count
end

# Main execution
input = fetch_input
rotations = input.strip.split("\n")

part1_solution = solve_part1(rotations)
part2_solution = solve_part2(rotations)

puts "Part 1 Solution: #{part1_solution}. Part 2 Solution: #{part2_solution}"
