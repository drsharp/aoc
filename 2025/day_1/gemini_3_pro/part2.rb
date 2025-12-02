# solution.rb

# Configuration
INPUT_FILE = 'input.txt'
DIAL_SIZE = 100
START_POSITION = 50

def solve_puzzle
  # Verify input file exists
  unless File.exist?(INPUT_FILE)
    puts "Error: '#{INPUT_FILE}' not found."
    return
  end

  # Initialize state
  current_pos = START_POSITION
  part1_count = 0
  part2_count = 0

  File.foreach(INPUT_FILE) do |line|
    instruction = line.strip
    next if instruction.empty?

    # Parse instruction
    direction = instruction[0]      # 'L' or 'R'
    amount = instruction[1..-1].to_i # Number of clicks

    # --- Part 2 Logic: Counting Passings ---
    # We need to calculate how many times the dial hits '0' during this movement.
    # Instead of iterating one by one (which would be slow for large amounts like R1000),
    # we calculate the distance to the *next* 0.
    
    dist_to_zero = 0

    if direction == 'R'
      # Moving Right (increasing numbers: 0 -> 1 -> ... -> 99 -> 0)
      # Distance to next 0 is simply (100 - current).
      # If current is 0, we need 100 steps to wrap all the way around back to 0.
      dist_to_zero = DIAL_SIZE - current_pos
    else
      # Moving Left (decreasing numbers: 0 -> 99 -> ... -> 1 -> 0)
      # Distance to next 0 is simply current position.
      # If current is 0, we need 100 steps to wrap backwards to 0.
      dist_to_zero = (current_pos == 0) ? DIAL_SIZE : current_pos
    end

    # If the rotation amount is large enough to cover the distance to 0:
    if amount >= dist_to_zero
      # We hit 0 at least once.
      # We count 1 for the first hit, plus 1 for every full circle (100 clicks) remaining.
      remaining_clicks = amount - dist_to_zero
      hits = 1 + (remaining_clicks / DIAL_SIZE)
      part2_count += hits
    end

    # --- Movement Logic ---
    case direction
    when 'R'
      # Add amount, modulo 100 wraps correctly (99+1 -> 0)
      current_pos = (current_pos + amount) % DIAL_SIZE
    when 'L'
      # Subtract amount, modulo 100 wraps correctly (0-1 -> 99)
      current_pos = (current_pos - amount) % DIAL_SIZE
    end

    # --- Part 1 Logic: End Position ---
    # Check if the dial is resting on 0 at the end of the rotation
    if current_pos == 0
      part1_count += 1
    end
  end

  # Output result in the requested format
  puts "Part 1 Solution: #{part1_count}. Part 2 Solution: #{part2_count}"
end

solve_puzzle
