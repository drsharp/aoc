# solution.rb

# Configuration for the problem
INPUT_FILE = 'input.txt'
DIAL_SIZE = 100
START_POSITION = 50

def solve_part_1
  # Check if the input file exists
  unless File.exist?(INPUT_FILE)
    puts "Error: '#{INPUT_FILE}' not found. Please ensure the file is in the same directory."
    return
  end

  # The dial starts pointing at 50.
  current_pos = START_POSITION
  
  # We need to count the number of times the dial is left pointing at 0
  # after a rotation is complete.
  password_count = 0

  # Read instructions from the local file line by line
  File.foreach(INPUT_FILE) do |line|
    instruction = line.strip
    next if instruction.empty?

    # Parse the instruction
    # The first character is the direction (L or R)
    # The rest of the string is the integer amount
    direction = instruction[0]
    amount = instruction[1..-1].to_i

    # Apply rotation based on direction
    case direction
    when 'R'
      # Rotating Right increases the number.
      # We use modulo (%) to handle the circular wrapping (0-99).
      # e.g., (99 + 1) % 100 = 0
      current_pos = (current_pos + amount) % DIAL_SIZE
    when 'L'
      # Rotating Left decreases the number.
      # Ruby's modulo operator handles negative operands mathematically correctly for this context.
      # e.g., (0 - 1) % 100 = 99
      current_pos = (current_pos - amount) % DIAL_SIZE
    end

    # Check if the dial landed on 0
    if current_pos == 0
      password_count += 1
    end
  end

  # Output the final solution
  puts "Part 1 Solution: #{password_count}"
end

# Run the solution
solve_part_1
