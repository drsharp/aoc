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

def unload_rolls(rows, unloaded_count = 0, recurse_count = 0)
  this_round_count = 0

  row_count = rows.size
  col_count = rows.first.length

  # output visually, just for testing
  # puts "-"*(col_count+1)
  # puts rows.join("\n")
  # puts "-"*(col_count+1)

  positions_to_remove = []

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
          this_round_count += 1
          positions_to_remove << {x: row_idx, y: col_idx}
        end
      end
    end # col_count
  end # row_count

  # adjust the rows
  positions_to_remove.each do |point|
    rows[point[:x]][point[:y]] = "x" # removed
  end

  if this_round_count > 0
    unloaded_count += this_round_count
    unload_rolls(rows, unloaded_count, recurse_count + 1)
  else
    puts "Solution for Day 4, Part 2: #{unloaded_count}"
  end
end

rows = File.readlines(ARGV.first, chomp: true)
unload_rolls(rows) # recurse

# ---------------------------------------------------
# --- Part Two ---

# Now, the Elves just need help accessing as much of the paper as they can.

# Once a roll of paper can be accessed by a forklift, it can be removed. Once a roll of paper is removed, the forklifts might be able to access more rolls of paper, which they might also be able to remove. How many total rolls of paper could the Elves remove if they keep repeating this process?

# Starting with the same example as above, here is one way you could remove as many rolls of paper as possible, using highlighted @ to indicate that a roll of paper is about to be removed, and using x to indicate that a roll of paper was just removed:

# Initial state:
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

# Remove 13 rolls of paper:
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

# Remove 12 rolls of paper:
# .......x..
# .@@.x.x.@x
# x@@@@...@@
# x.@@@@..x.
# .@.@@@@.x.
# .x@@@@@@.x
# .x.@.@.@@@
# ..@@@.@@@@
# .x@@@@@@@.
# ....@@@...

# Remove 7 rolls of paper:
# ..........
# .x@.....x.
# .@@@@...xx
# ..@@@@....
# .x.@@@@...
# ..@@@@@@..
# ...@.@.@@x
# ..@@@.@@@@
# ..x@@@@@@.
# ....@@@...

# Remove 5 rolls of paper:
# ..........
# ..x.......
# .x@@@.....
# ..@@@@....
# ...@@@@...
# ..x@@@@@..
# ...@.@.@@.
# ..x@@.@@@x
# ...@@@@@@.
# ....@@@...

# Remove 2 rolls of paper:
# ..........
# ..........
# ..x@@.....
# ..@@@@....
# ...@@@@...
# ...@@@@@..
# ...@.@.@@.
# ...@@.@@@.
# ...@@@@@x.
# ....@@@...

# Remove 1 roll of paper:
# ..........
# ..........
# ...@@.....
# ..x@@@....
# ...@@@@...
# ...@@@@@..
# ...@.@.@@.
# ...@@.@@@.
# ...@@@@@..
# ....@@@...

# Remove 1 roll of paper:
# ..........
# ..........
# ...x@.....
# ...@@@....
# ...@@@@...
# ...@@@@@..
# ...@.@.@@.
# ...@@.@@@.
# ...@@@@@..
# ....@@@...

# Remove 1 roll of paper:
# ..........
# ..........
# ....x.....
# ...@@@....
# ...@@@@...
# ...@@@@@..
# ...@.@.@@.
# ...@@.@@@.
# ...@@@@@..
# ....@@@...

# Remove 1 roll of paper:
# ..........
# ..........
# ..........
# ...x@@....
# ...@@@@...
# ...@@@@@..
# ...@.@.@@.
# ...@@.@@@.
# ...@@@@@..
# ....@@@...

# Stop once no more rolls of paper are accessible by a forklift. In this example, a total of 43 rolls of paper can be removed.

# Start with your original diagram. How many rolls of paper in total can be removed by the Elves and their forklifts?
