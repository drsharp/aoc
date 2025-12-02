#!/usr/bin/env ruby

# You arrive at the secret entrance to the North Pole base ready to start decorating. Unfortunately, the password seems to have been changed, so you can't get in. A document taped to the wall helpfully explains:

# "Due to new security protocols, the password is locked in the safe below. Please see the attached document for the new combination."

# The safe has a dial with only an arrow on it; around the dial are the numbers 0 through 99 in order. As you turn the dial, it makes a small click noise as it reaches each number.

# The attached document (your puzzle input) contains a sequence of rotations, one per line, which tell you how to open the safe. A rotation starts with an L or R which indicates whether the rotation should be to the left (toward lower numbers) or to the right (toward higher numbers). Then, the rotation has a distance value which indicates how many clicks the dial should be rotated in that direction.

# So, if the dial were pointing at 11, a rotation of R8 would cause the dial to point at 19. After that, a rotation of L19 would cause it to point at 0.

# Because the dial is a circle, turning the dial left from 0 one click makes it point at 99. Similarly, turning the dial right from 99 one click makes it point at 0.

# So, if the dial were pointing at 5, a rotation of L10 would cause it to point at 95. After that, a rotation of R5 could cause it to point at 0.

# The dial starts by pointing at 50.

# You could follow the instructions, but your recent required official North Pole secret entrance security training seminar taught you that the safe is actually a decoy. The actual password is the number of times the dial is left pointing at 0 after any rotation in the sequence.

# For example, suppose the attached document contained the following rotations:

# L68
# L30
# R48
# L5
# R60
# L55
# L1
# L99
# R14
# L82

# Following these rotations would cause the dial to move as follows:

#     The dial starts by pointing at 50.
#     The dial is rotated L68 to point at 82.
#     The dial is rotated L30 to point at 52.
#     The dial is rotated R48 to point at 0.
#     The dial is rotated L5 to point at 95.
#     The dial is rotated R60 to point at 55.
#     The dial is rotated L55 to point at 0.
#     The dial is rotated L1 to point at 99.
#     The dial is rotated L99 to point at 0.
#     The dial is rotated R14 to point at 14.
#     The dial is rotated L82 to point at 32.

# Because the dial points at 0 a total of three times during this process, the password in this example is 3.

# Analyze the rotations in your attached document. What's the actual password to open the door?

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
      new_position = (DIAL_MAX + DIAL_MIN + 1) + new_position
    end
    adjusted_position = new_position
  elsif new_position > DIAL_MAX # wraps to right (> 99)
    while new_position > DIAL_MAX
      new_position = new_position - (DIAL_MAX + DIAL_MIN + 1)
    end
    adjusted_position = new_position
  end

  puts "Line #{line_count}: '#{line}', current_position=#{current_position}, new_position=#{new_position}, adjusted_position=#{adjusted_position}"
  points_to_zero_count += 1 if adjusted_position == 0
  current_position = adjusted_position
end

puts "Solution for Day 1: Points to Zero count = #{points_to_zero_count}"
