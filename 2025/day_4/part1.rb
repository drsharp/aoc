#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

total = 0

# Build a 2-D array of lines (rows) and characters (cols)
# Checking char at position row=R, col=C means:
# check R-1xC-1, R-1xC, R-1C+1, RxC-1, RxC+1, R+1xC-1, R+1xC, R+1xC+1
# if any is "off grid" it's a false

rows = File.readlines(ARGV.first, chomp: true)
row_count = rows.size
col_count = rows.first.length
0.upto(row_count-1) do |row_idx|
  0.upto(col_count-1) do |col_idx|
    # Check 3 above
    if rows[row_idx][col_idx] == "@" # is a roll
      surrounding = 0
      surrounding += 1 if row_idx-1 >= 0 && col_idx-1 >= 0 && rows[row_idx-1][col_idx-1] == "@" # UL
      surrounding += 1 if row_idx-1 >= 0 && rows[row_idx-1][col_idx] == "@" # U
      surrounding += 1 if row_idx-1 >= 0 && col_idx+1 < col_count && rows[row_idx-1][col_idx+1] == "@" # UR

      surrounding += 1 if col_idx-1 >= 0 && rows[row_idx][col_idx-1] == "@" # L
      surrounding += 1 if col_idx+1 < col_count && rows[row_idx][col_idx+1] == "@" # R

      surrounding += 1 if row_idx+1 < row_count && col_idx-1 >= 0 && rows[row_idx+1][col_idx-1] == "@" # LL
      surrounding += 1 if row_idx+1 < row_count && rows[row_idx+1][col_idx] == "@" # L
      surrounding += 1 if row_idx+1 < row_count && col_idx+1 < col_count && rows[row_idx+1][col_idx+1] == "@" # LR

      if surrounding < 4
        total += 1
      end
    end
  end
end

puts "Solution for Day 4, Part 1: #{total}"

# ---------------------------------------------------
# --- Day 4: Printing Department ---

# You ride the escalator down to the printing department. They're clearly getting ready for Christmas; they have lots of large rolls of paper everywhere, and there's even a massive printer in the corner (to handle the really big print jobs).

# Decorating here will be easy: they can make their own decorations. What you really need is a way to get further into the North Pole base while the elevators are offline.

# "Actually, maybe we can help with that," one of the Elves replies when you ask for help. "We're pretty sure there's a cafeteria on the other side of the back wall. If we could break through the wall, you'd be able to keep moving. It's too bad all of our forklifts are so busy moving those big rolls of paper around."

# If you can optimize the work the forklifts are doing, maybe they would have time to spare to break through the wall.

# The rolls of paper (@) are arranged on a large grid; the Elves even have a helpful diagram (your puzzle input) indicating where everything is located.

# For example:

# ..@@.@@@@.
# @@@.@.@.@@
# @@@@@.@.@@
# @.@@@@..@.
# @@.@@@@.@@
# .@@@@@@@.@
# .@.@.@.@@@
# @.@@@.@@@@
# .@@@@@@@@.
# @.@.@@@.@.

# The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent positions. If you can figure out which rolls of paper the forklifts can access, they'll spend less time looking and more time breaking down the wall to the cafeteria.

# In this example, there are 13 rolls of paper that can be accessed by a forklift (marked with x):

# ..xx.xx@x.
# x@@.@.@.@@
# @@@@@.x.@@
# @.@@@@..@.
# x@.@@@@.@x
# .@@@@@@@.@
# .@.@.@.@@@
# x.@@@.@@@@
# .@@@@@@@@.
# x.x.@@@.x.

# Consider your complete diagram of the paper roll locations. How many rolls of paper can be accessed by a forklift?
