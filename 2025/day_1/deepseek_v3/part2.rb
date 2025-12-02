# Advent of Code Day 1 - Parts 1 & 2 Solution

# This script will:
# For Part 1:
# 1. Start with the dial at position 50
# 2. Process each rotation instruction (L/R followed by a number)
# 3. For each instruction, update the dial position (wrapping around 0-99)
# 4. Count how many times the dial points to 0 after any rotation
#
# For Part 2:
# 1. Additionally count all times the dial passes through 0 during rotations
# 2. Handle large rotations that might pass through 0 multiple times
# 3. Output both solutions

def read_input(filename)
  File.readlines(filename).map(&:chomp)
end

def process_rotations(instructions)
  position = 50
  zero_count_part1 = 0
  zero_count_part2 = 0

  instructions.each do |instruction|
    direction = instruction[0]
    distance = instruction[1..-1].to_i
    new_position = position

    # Calculate the change in position
    delta = direction == 'L' ? -distance : distance

    # For Part 2: Count zero crossings during rotation
    if delta != 0
      step = delta > 0 ? 1 : -1
      (1..delta.abs).each do |i|
        intermediate = (position + step * i) % 100
        intermediate += 100 if intermediate < 0
        zero_count_part2 += 1 if intermediate == 0
      end
    end

    # Update position for Part 1 counting (same as original)
    new_position += delta
    new_position %= 100
    new_position += 100 if new_position < 0

    # Count if we're at position 0 after rotation (Part 1)
    zero_count_part1 += 1 if new_position == 0

    position = new_position
  end

  [zero_count_part1, zero_count_part2]
end

# Main execution
begin
  instructions = read_input('input.txt')
  part1, part2 = process_rotations(instructions)
  puts "Part 1 Solution: #{part1}. Part 2 Solution: #{part2}"
rescue Errno::ENOENT
  puts "Error: Could not find input.txt file. Please ensure it exists in the same directory."
end
