# Advent of Code Day 1 - Part 1 Solution

# This script will:
# 1. Start with the dial at position 50
# 2. Process each rotation instruction (L/R followed by a number)
# 3. For each instruction, update the dial position (wrapping around 0-99)
# 4. Count how many times the dial points to 0 after any rotation
# 5. Output the final count

# Read input from a local file
def read_input(filename)
  File.readlines(filename).map(&:chomp)
end

# Process the rotations and count zero crossings
def process_rotations(instructions)
  position = 50  # Starting position
  zero_count = 0

  instructions.each do |instruction|
    # Parse direction and distance
    direction = instruction[0]
    distance = instruction[1..-1].to_i

    # Calculate new position based on direction
    if direction == 'L'
      position -= distance
    else # 'R'
      position += distance
    end

    # Handle wrapping around (modulo 100)
    position %= 100
    position += 100 if position < 0  # Handle negative numbers correctly

    # Count if we're at position 0
    zero_count += 1 if position == 0
  end

  zero_count
end

# Main execution
begin
  # Read input from file
  instructions = read_input('input.txt')

  # Process instructions and get zero count
  solution = process_rotations(instructions)

  # Output the solution
  puts "Part 1 Solution: #{solution}"
rescue Errno::ENOENT
  puts "Error: Could not find input.txt file. Please ensure it exists in the same directory."
end
