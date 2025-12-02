#!/usr/bin/env ruby
require 'net/http'
require 'uri'

# Fetch the input data from the Advent of Code website
def fetch_input
  url = 'https://adventofcode.com/2025/day/1/input'
  uri = URI.parse(url)
  
  begin
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      response.body
    else
      File.read('input.txt')
    end
  rescue
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
    
    # Count how many times we land on 0 during the rotation
    # We land on 0 when (position ± k) % 100 == 0 for k in 1..distance
    if direction == 'L'
      # Moving left: position - k ≡ 0 (mod 100)
      # This means k ≡ position (mod 100)
      # So k can be: position, position + 100, position + 200, etc.
      # Count how many such k are in range [1, distance]
      if distance >= position && position > 0
        # First crossing at k = position, then every 100 steps
        zero_count += 1 + (distance - position) / 100
      elsif position == 0 && distance > 0
        # Starting at 0, moving left, we cross at k = 100, 200, ...
        zero_count += distance / 100
      end
      position = (position - distance) % 100
    elsif direction == 'R'
      # Moving right: position + k ≡ 0 (mod 100)
      # This means k ≡ -position ≡ (100 - position) (mod 100)
      # So k can be: (100 - position), (100 - position) + 100, etc.
      # Count how many such k are in range [1, distance]
      if position > 0 && distance >= (100 - position)
        # First crossing at k = (100 - position), then every 100 steps
        zero_count += 1 + (distance - (100 - position)) / 100
      elsif position == 0 && distance > 0
        # Starting at 0, moving right, we cross at k = 100, 200, ...
        zero_count += distance / 100
      end
      position = (position + distance) % 100
    end
  end
  
  zero_count
end

# Main execution
input = fetch_input
rotations = input.strip.split("\n")

part1_solution = solve_part1(rotations)
part2_solution = solve_part2(rotations)

puts "Part 1 Solution: #{part1_solution}. Part 2 Solution: #{part2_solution}"
