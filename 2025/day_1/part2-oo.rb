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

class Dial
  attr_reader :zero_stops, :zero_touches

  def initialize(leftmost=0, rightmost=99, start=50)
    @leftmost = leftmost
    @rightmost = rightmost
    @positions = [*leftmost..rightmost].map {|p| "Pos #{p}"}
    @start = start
    @current_position = start
    @current_value = @positions[@current_position]
    @zero_stops = 0
    @zero_touches = 0
  end

  def pointing_at
    @positions[@current_position]
  end

  def spin_left(count)
    count.times do
      click_left
      @zero_touches += 1 if @current_position == 0
    end

    @zero_stops += 1 if @current_position == 0
  end

  def spin_right(count)
    count.times do
      click_right
      @zero_touches += 1 if @current_position == 0
    end

    @zero_stops += 1 if @current_position == 0
  end

  def to_s
    "Dial from #{@leftmost} to #{@rightmost}: currently at '#{pointing_at}' with current position=#{@current_position}. Zero stops=#{@zero_stops}, Zero touches=#{@zero_touches}"
  end

  private

  def click_left
    if @current_position == @leftmost
      @current_position = @rightmost
    else
      @current_position -= 1
    end
  end

  def click_right
    if @current_position == @rightmost
      @current_position = @leftmost
    else
      @current_position += 1
    end
  end
end


if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./solution.rb <inputfile>"
  exit
end

# Practicing with 0-9 for simplicity's sake
# [0123456789012345678901234567890123456789]
#                 ^
#                            ^

@dial = Dial.new
puts "Dial at start: #{@dial}"

lines = File.readlines(ARGV.first, chomp: true)
lines.each do |line, line_count|
  direction, clicks = line[0],line[1..]

  if direction == "L"
    @dial.spin_left(clicks.to_i)
  elsif direction == "R"
    @dial.spin_right(clicks.to_i)
  else
    raise "Unknown direction for line #{line}"
  end

  puts "Line #{line_count}: '#{line}', Dial pointing at=#{@dial.pointing_at}"
end

puts "Solution for Day 1: Points to Zero count = #{@dial.zero_stops}, Passes Zero count = #{@dial.zero_touches}"
