# Read the input file
input = File.read('input.txt')

# Initialize the dial position and count of zeros
position = 50
zero_count = 0

# Process each rotation
input.each_line do |line|
  line.strip!
  next if line.empty?

  # Extract direction and steps
  direction, steps = line[0], line[1..].to_i

  # Update position based on direction
  if direction == 'L'
    position = (position - steps) % 100
  else
    position = (position + steps) % 100
  end

  # Check if position is 0 and increment count
  zero_count += 1 if position == 0
end

# Output the solution
puts "Part 1 Solution: #{zero_count}"
