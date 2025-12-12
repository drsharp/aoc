#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code - Day 7: Laboratories
#
# Part 1:
#   Classical manifold:
#     - A tachyon beam enters at S and always moves downward.
#     - Grid characters:
#         '.' : empty space (beam passes straight through)
#         '^' : splitter (beam stops; two new beams appear immediately
#                       to the left and right, continuing downward)
#         'S' : start (only one in the grid)
#     - Beams that move off the left/right edges or below the grid vanish.
#     - In this classical setting, overlapping beams in the same column
#       are effectively just a single beam (they merge).
#   Goal: Count how many times any (classical) beam hits a splitter '^'.
#
# Part 2:
#   Quantum manifold:
#     - A *single* tachyon particle enters at S.
#     - At each splitter '^', *time* splits:
#         in one timeline the particle goes left,
#         in the other it goes right.
#     - We must count how many distinct final timelines exist after the
#       particle completes *all* possible journeys (i.e., all branches
#       eventually leave the manifold).
#   Key idea:
#     - Each time a particle path reaches a splitter, the number of
#       timelines that pass through that splitter doubles (one left,
#       one right for each incoming timeline).
#     - Different paths that re-merge are still different timelines.
#     - So we track counts (how many timelines reach each cell), not just
#       presence/absence like in Part 1.
#
# The grid may be non-rectangular:
#   - Each row can have its own length.
#   - Positions beyond a row's length are outside the manifold; any beam
#     or particle moving there exits immediately.
#
# Output:
#   A single line:
#     Part 1 Solution: XXX. Part 2 Solution: YYY

# -----------------------------
# Input helpers
# -----------------------------

def read_grid
  path = File.join(__dir__, 'input.txt')
  abort "Input file not found: #{path}" unless File.exist?(path)

  # Keep raw rows as-is (possibly ragged). Strip trailing newlines only.
  grid = File.read(path).lines.map!(&:chomp)
  abort 'Empty input' if grid.empty?

  grid
end

def find_start(grid)
  grid.each_with_index do |row, r|
    c = row.index('S')
    return [r, c] if c
  end
  abort "No starting position 'S' found in grid."
end

# -----------------------------
# Part 1: classical splits
# -----------------------------
#
# We simulate classical beams using booleans:
#   beams[c] == true  => there is at least one beam entering the current row
#                        at column c from above.
# Multiple beams in the same column merge and behave as a single beam,
# which matches the intended physical behavior and the example.

def count_splits_classical(grid)
  height = grid.size
  # Max width across all rows (columns are 0...(max_width-1))
  max_width = grid.map(&:length).max || 0

  start_row, start_col = find_start(grid)

  # The beam enters *below* S, i.e., into the row just after S.
  first_row = start_row + 1
  return 0 if first_row >= height

  # beams[c] indicates if a beam is entering row `r` at column `c`
  beams = Array.new(max_width, false)
  beams[start_col] = true

  split_count = 0

  (first_row...height).each do |r|
    row_str = grid[r]
    row_len = row_str.length

    next_beams = Array.new(max_width, false)

    beams.each_index do |c|
      next unless beams[c]

      # If this column doesn't exist on this row, the beam exits.
      next if c < 0 || c >= row_len

      cell = row_str[c]

      if cell == '^'
        # A classical beam hits a splitter:
        # - count one split (per column per row),
        # - the incoming beam stops,
        # - two new beams appear to the left and right (for the next row).
        split_count += 1

        left  = c - 1
        right = c + 1

        next_beams[left]  = true if left >= 0
        next_beams[right] = true if right < max_width
      else
        # Empty space or 'S' (or any non-splitter): beam continues straight down.
        next_beams[c] = true
      end
    end

    beams = next_beams
  end

  split_count
end

# -----------------------------
# Part 2: quantum timelines
# -----------------------------
#
# We track how many distinct timelines reach each position.
#
# State:
#   timelines[c] = number of timelines entering the current row at column c.
#
# Processing:
#   - At a non-splitter cell: timelines just pass through:
#       next_timelines[c] += timelines[c]
#   - At a splitter '^':
#       each incoming timeline splits into left and right:
#       next_timelines[c-1] += timelines[c]
#       next_timelines[c+1] += timelines[c]
#
# Exits:
#   - If a timeline would move into a column outside the current row's length,
#     it exits the manifold and becomes a final timeline.
#   - If a split sends a branch to a column index that doesn't exist in any
#     row (outside [0, max_width-1]), that branch is also a final timeline.
#   - After the last row, any remaining timelines exit below the grid.
#
# The answer is the total number of final timelines.

def count_timelines_quantum(grid)
  height = grid.size
  max_width = grid.map(&:length).max || 0

  start_row, start_col = find_start(grid)
  # Particle enters into the row just below S.
  first_row = start_row + 1

  # If there is no row below S, the particle immediately exits: 1 timeline.
  return 1 if first_row >= height

  timelines = Array.new(max_width, 0)
  timelines[start_col] = 1

  total_final = 0

  # We process from the first row the particle enters (first_row)
  # down to a "virtual" row at index height where everything exits.
  (first_row..height).each do |r|
    # When r == height, there is no actual row: all remaining timelines exit.
    if r == height
      total_final += timelines.sum
      break
    end

    row_str = grid[r]
    row_len = row_str.length

    next_timelines = Array.new(max_width, 0)

    timelines.each_index do |c|
      count = timelines[c]
      next if count.zero?

      # If this column doesn't exist on this row, these timelines exit now.
      if c < 0 || c >= row_len
        total_final += count
        next
      end

      cell = row_str[c]

      if cell == '^'
        # Each timeline splits into two. For quantum behavior:
        # - left or right branches that leave the global manifold width
        #   become final timelines immediately.
        left  = c - 1
        right = c + 1

        if left >= 0
          next_timelines[left] += count
        else
          total_final += count
        end

        if right < max_width
          next_timelines[right] += count
        else
          total_final += count
        end
      else
        # Non-splitter: timeline continues straight down.
        next_timelines[c] += count
      end
    end

    timelines = next_timelines
  end

  total_final
end

# -----------------------------
# Main
# -----------------------------
if __FILE__ == $PROGRAM_NAME
  grid = read_grid

  part1 = count_splits_classical(grid)
  part2 = count_timelines_quantum(grid)

  puts "Part 1 Solution: #{part1}. Part 2 Solution: #{part2}"
end
