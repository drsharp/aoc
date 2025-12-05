#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

total = 0

# Use Ruby's built-in Range
fresh_ids = []
rows = File.readlines(ARGV.first, chomp: true)
rows.each do |row|
  break if row.empty?

  left,right = row.split("-").map(&:to_i)
  fresh_ids = fresh_ids.union Range.new(left, right).to_a
end

total = fresh_ids.length
puts "Solution for Day 5, Part 1: #{total}"

# ---------------------------------------------------
# --- Part Two ---

# The Elves start bringing their spoiled inventory to the trash chute at the back of the kitchen.

# So that they can stop bugging you when they get new inventory, the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh. An ingredient ID is still considered fresh if it is in any range.

# Now, the second section of the database (the available ingredient IDs) is irrelevant. Here are the fresh ingredient ID ranges from the above example:

# 3-5
# 10-14
# 16-20
# 12-18

# The ingredient IDs that these ranges consider to be fresh are 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20. So, in this example, the fresh ingredient ID ranges consider a total of 14 ingredient IDs to be fresh.

# Process the database file again. How many ingredient IDs are considered to be fresh according to the fresh ingredient ID ranges?
