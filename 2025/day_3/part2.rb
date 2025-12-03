#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

total = 0

lines = File.readlines(ARGV.first, chomp: true)
lines.each do |line, line_count|
  line_as_chars = line.split(//)
  subset = line_as_chars
  chars = []
  12.downto(1).each do |back_count|
    chars_to_check = subset[0..-back_count]
    max_char = chars_to_check.max
    max_char_index = chars_to_check.index(max_char)
    chars << max_char
    # reset subset to the the rest
    subset = subset[(max_char_index+1)..-1]
  end

  joltage = chars.join.to_i

  total += joltage
end

puts "Solution for Day 3, Part 2: #{total}"

# ---------------------------------------------------
# --- Part Two ---

# The escalator doesn't move. The Elf explains that it probably needs more joltage to overcome the static friction of the system and hits the big red "joltage limit safety override" button. You lose count of the number of times she needs to confirm "yes, I'm sure" and decorate the lobby a bit while you wait.

# Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank.

# The joltage output for the bank is still the number formed by the digits of the batteries you've turned on; the only difference is that now there will be 12 digits in each bank's joltage output instead of two.

# Consider again the example from before:

# 987654321111111
# 811111111111119
# 234234234234278
# 818181911112111

# Now, the joltages are much larger:

#     In 987654321111111, the largest joltage can be found by turning on everything except some 1s at the end to produce 987654321111.
#     In the digit sequence 811111111111119, the largest joltage can be found by turning on everything except some 1s, producing 811111111119.
#     In 234234234234278, the largest joltage can be found by turning on everything except a 2 battery, a 3 battery, and another 2 battery near the start to produce 434234234278.
#     In 818181911112111, the joltage 888911112111 is produced by turning on everything except some 1s near the front.

# The total output joltage is now much larger: 987654321111 + 811111111119 + 434234234278 + 888911112111 = 3121910778619.

# What is the new total output joltage?
