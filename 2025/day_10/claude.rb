#!/usr/bin/env ruby

# Advent of Code 2025 - Day 10 Part 2
# Using GLPK (GNU Linear Programming Kit) to solve as ILP

require 'tempfile'

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./claude.rb <inputfile>"
  exit
end

def solve_machine(buttons, targets)
  # buttons: array of arrays, each sub-array contains the counter indices that button affects
  # targets: array of target values for each counter

  num_buttons = buttons.length
  num_counters = targets.length

  # Generate GMPL (GNU MathProg Language) model
  model = <<~GMPL
    /* Day 10 Part 2 - Button Press Optimization */

    /* Number of times each button is pressed */
    var x{i in 1..#{num_buttons}} integer >= 0;

    /* Objective: minimize total presses */
    minimize total_presses: sum{i in 1..#{num_buttons}} x[i];

    /* Constraints: each counter must reach its target */
  GMPL

  # Add constraints for each counter
  num_counters.times do |counter|
    # Find which buttons affect this counter
    terms = []
    buttons.each_with_index do |positions, btn_idx|
      if positions.include?(counter)
        terms << "x[#{btn_idx + 1}]"
      end
    end

    if terms.any?
      model += "s.t. counter#{counter}: #{terms.join(' + ')} = #{targets[counter]};\n"
    elsif targets[counter] != 0
      # No button affects this counter but target is non-zero - impossible
      return nil
    end
  end

  model += "\nend;\n"

  # Write model to temp file and solve
  result = nil
  Tempfile.create(['day10', '.mod']) do |model_file|
    model_file.write(model)
    model_file.flush

    Tempfile.create(['day10', '.sol']) do |sol_file|
      # Run glpsol
      output = `glpsol --math #{model_file.path} -o #{sol_file.path} 2>&1`

      if $?.success?
        # Parse solution file
        sol_content = File.read(sol_file.path)

        # Look for the objective value
        if sol_content =~ /Objective:\s+total_presses\s+=\s+(\d+)/
          result = $1.to_i
        end
      else
        STDERR.puts "GLPK failed: #{output}"
      end
    end
  end

  result
end

total_presses = 0
failed = []

File.readlines(ARGV.first, chomp: true).each_with_index do |line, idx|
  # Parse the line
  # buttons: (3) (1,3) (2) etc - each button lists which counters it affects
  buttons = line.scan(/\(([^)]+)\)/).flatten.map { |b| b.split(",").map(&:to_i) }

  # joltage targets: {3,5,4,7}
  targets = line[/\{([^}]+)\}/, 1].split(",").map(&:to_i)

  result = solve_machine(buttons, targets)

  if result
    puts "Machine #{idx + 1}: #{result} presses"
    total_presses += result
  else
    puts "Machine #{idx + 1}: ERROR - No solution found!"
    failed << idx + 1
  end
end

if failed.any?
  puts "\nFailed machines: #{failed.join(', ')}"
end

puts "\nSolution for Day 10, Part 2: #{total_presses}"
