#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

# [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
# [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
# [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}

# Configuring the first machine's counters requires a minimum of 10 button presses. One way to do this is by pressing (3) once, (1,3) three times, (2,3) three times, (0,2) once, and (0,1) twice.

# Start:        [0, 0, 0, 0]
# Press:   3 => [0, 0, 0, 1]

# Press: 1,3 => [0, 1, 0, 2]
# Press: 1,3 => [0, 2, 0, 3]
# Press: 1,3 => [0, 3, 0, 4]

# Press: 2,3 => [0, 3, 1, 5]
# Press: 2,3 => [0, 3, 2, 6]
# Press: 2,3 => [0, 3, 3, 7]

# Press: 0,2 => [1, 3, 4, 7]

# Press: 0,1 => [2, 4, 4, 7]
# Press: 0,1 => [3, 5, 4, 7]


class Lights
  def initialize(rule, combo)
    @rule = rule
    @bulbs = Array.new(rule.length, 0) # all are 0
    @combo = combo
  end

  def toggle!
    @combo.each do |button|
      button.split(",").each do |position|
        @bulbs[position.to_i] += 1
      end
    end
  end

  def is_correct?
    @bulbs == @rule
  end

  def to_s
    "[" + @bulbs.map{|b| b ? "#" : "." }.to_s + "]"
  end
end


@button_presses = []
File.readlines(ARGV.first, chomp: true).each do |line|
  rule = line[/\[([^\]]+)\]/, 1].chars.map { |c| c == "#" } # ".##." => [false, true, true, false]
  buttons = line.scan(/\(([^)]+)\)/).flatten   # ["3", "1,3", "2", "2,3", "0,2", "0,1"]
  joltages = line[/\{([^}]+)\}/, 1]            # "3,5,4,7"

  max = 10 # set to button count

  catch(:found) do
    (1..max).each do |permutation|
      puts "Pressing button combos #{permutation} time(s)"
      result = buttons.repeated_permutation(permutation).to_a
      result.each do |combo|
        lights = Lights.new(joltages, combo)
        lights.toggle!
        if lights.is_correct?
          puts "Found solution with #{permutation} presses"
          @button_presses << permutation
          throw(:found)
        end
      end
    end
  end
end

puts "Button Presses: #{@button_presses}"
@solution = @button_presses.sum

puts "Solution for Day 10, Part 2: #{@solution}"

# ---------------------------------------------------
# --- Part Two ---

# All of the machines are starting to come online! Now, it's time to worry about the joltage requirements.

# Each machine needs to be configured to exactly the specified joltage levels to function properly. Below the buttons on each machine is a big lever that you can use to switch the buttons from configuring the indicator lights to increasing the joltage levels. (Ignore the indicator light diagrams.)

# The machines each have a set of numeric counters tracking its joltage levels, one counter per joltage requirement. The counters are all initially set to zero.

# So, joltage requirements like {3,5,4,7} mean that the machine has four counters which are initially 0 and that the goal is to simultaneously configure the first counter to be 3, the second counter to be 5, the third to be 4, and the fourth to be 7.

# The button wiring schematics are still relevant: in this new joltage configuration mode, each button now indicates which counters it affects, where 0 means the first counter, 1 means the second counter, and so on. When you push a button, each listed counter is increased by 1.

# So, a button wiring schematic like (1,3) means that each time you push that button, the second and fourth counters would each increase by 1. If the current joltage levels were {0,1,2,3}, pushing the button would change them to be {0,2,2,4}.

# You can push each button as many times as you like. However, your finger is getting sore from all the button pushing, and so you will need to determine the fewest total presses required to correctly configure each machine's joltage level counters to match the specified joltage requirements.

# Consider again the example from before:

# [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
# [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
# [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}

# Configuring the first machine's counters requires a minimum of 10 button presses. One way to do this is by pressing (3) once, (1,3) three times, (2,3) three times, (0,2) once, and (0,1) twice.

# Configuring the second machine's counters requires a minimum of 12 button presses. One way to do this is by pressing (0,2,3,4) twice, (2,3) five times, and (0,1,2) five times.

# Configuring the third machine's counters requires a minimum of 11 button presses. One way to do this is by pressing (0,1,2,3,4) five times, (0,1,2,4,5) five times, and (1,2) once.

# So, the fewest button presses required to correctly configure the joltage level counters on all of the machines is 10 + 12 + 11 = 33.

# Analyze each machine's joltage requirements and button wiring schematics. What is the fewest button presses required to correctly configure the joltage level counters on all of the machines?
