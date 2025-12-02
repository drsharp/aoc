#!/usr/bin/env ruby

# --- Part Two ---

# You're sure that's the right password, but the door won't open. You knock, but nobody answers. You build a snowman while you think.

# As you're rolling the snowballs for your snowman, you find another security document that must have fallen into the snow:

# "Due to newer security protocols, please use password method 0x434C49434B until further notice."

# You remember from the training seminar that "method 0x434C49434B" means you're actually supposed to count the number of times any click causes the dial to point at 0, regardless of whether it happens during a rotation or at the end of one.

# Following the same rotations as in the above example, the dial points at zero a few extra times during its rotations:

#     The dial starts by pointing at 50.
#     The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
#     The dial is rotated L30 to point at 52.
#     The dial is rotated R48 to point at 0.
#     The dial is rotated L5 to point at 95.
#     The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
#     The dial is rotated L55 to point at 0.
#     The dial is rotated L1 to point at 99.
#     The dial is rotated L99 to point at 0.
#     The dial is rotated R14 to point at 14.
#     The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.

# In this example, the dial points at 0 three times at the end of a rotation, plus three more times during a rotation. So, in this example, the new password would be 6.

# Be careful: if the dial were pointing at 50, a single rotation like R1000 would cause the dial to point at 0 ten times before returning back to 50!

# Using password method 0x434C49434B, what is the password to open the door?


STARTING_POSITION = 50
DIAL_MAX = 99
DIAL_MIN = 0

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./solution.rb <inputfile>"
  exit
end

# Practicing with 0-9 for simplicity's sake
# [0123456789012345678901234567890123456789]
#                 ^
#                            ^

current_position = STARTING_POSITION
points_to_zero_count = 0
passes_zero_count = 0

lines = File.readlines(ARGV.first, chomp: true)
lines.each do |line, line_count|
  direction, clicks = line[0],line[1..]
  new_position = if direction == "L"
    current_position - clicks.to_i
  else
    current_position + clicks.to_i
  end

  adjusted_position = new_position # default is it doesn't wrap

  if new_position < DIAL_MIN # wraps to left (< 0)
    while new_position < DIAL_MIN
      passes_zero_count += 1
      new_position = (DIAL_MAX + DIAL_MIN + 1) + new_position
    end
    adjusted_position = new_position
  elsif new_position > DIAL_MAX # wraps to right (> 99)
    while new_position > DIAL_MAX
      passes_zero_count += 1
      new_position = new_position - (DIAL_MAX + DIAL_MIN + 1)
    end
    adjusted_position = new_position
  end

  puts "Line #{line_count}: '#{line}', current_position=#{current_position}, new_position=#{new_position}, adjusted_position=#{adjusted_position}"
  points_to_zero_count += 1 if adjusted_position == 0
  current_position = adjusted_position
end

puts "Solution for Day 1: Points to Zero count = #{points_to_zero_count}, Passes Zero count = #{passes_zero_count}"

# Solution for Day 1: Points to Zero count = 1139, Passes Zero count = 6676
# NOTE: 1139 was correct for part 1, but 6676 was incorrect for Part 2
