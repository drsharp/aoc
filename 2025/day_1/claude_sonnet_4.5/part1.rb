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
def solve_part1(input)
  # Parse the input into rotation instructions
  rotations = input.strip.split("\n")
  
  # Start position
  position = 50
  
  # Counter for times the dial points to 0
  zero_count = 0
  
  # Process each rotation
  rotations.each do |rotation|
    # Parse the direction (L or R) and distance
    direction = rotation[0]
    distance = rotation[1..-1].to_i
    
    # Apply the rotation
    if direction == 'L'
      # Left means subtract (toward lower numbers)
      position = (position - distance) % 100
    elsif direction == 'R'
      # Right means add (toward higher numbers)
      position = (position + distance) % 100
    end
    
    # Check if we landed on 0
    zero_count += 1 if position == 0
  end
  
  zero_count
end

# Main execution
input = fetch_input
part1_solution = solve_part1(input)

puts "Part 1 Solution: #{part1_solution}"
