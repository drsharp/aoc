# Read the input file
input = File.read('input.txt')

# Initialize the dial position and counts
position = 50
part1_count = 0
part2_count = 0

# Process each rotation
input.each_line do |line|
  line.strip!
  next if line.empty?

  # Extract direction and steps
  direction, steps = line[0], line[1..].to_i

  # Update position and count zeros for Part 2
  if direction == 'L'
    steps.times do
      position = (position - 1) % 100
      part2_count += 1 if position == 0
    end
  else
    steps.times do
      position = (position + 1) % 100
      part2_count += 1 if position == 0
    end
  end

  # Count zeros for Part 1
  part1_count += 1 if position == 0
end

# Output the solutions
puts "Part 1 Solution: #{part1_count}. Part 2 Solution: #{part2_count}"
