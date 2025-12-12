#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end


beam_tips =

# beam count = 1
# start at S position:
# when it hits ^, now there are 2 beams: 1 continues left, spawn new continues right
# when left hits ^, split as 1 continue left, new continues right


def beam_on(rows, beam_index)
  if rows == [] # all done
    puts "\t all done"
    @total_paths += 1
    return
  end

  next_row = rows.shift
  puts "in Beam On for #{beam_index} => #{next_row}"
  carats = (0...next_row.length).find_all { |i| next_row[i, 1] == '^' }

  if carats == []
    puts "\t no carats, just skip"
    beam_on(rows, beam_index) # just keep advancing
  else
    if carats.include?(beam_index) # split
      puts "\t carats split"
      beam_on(rows, beam_index - 1)
      beam_on(rows, beam_index + 1)
    end
  end
end

@total_paths = 0
rows = File.readlines(ARGV.first, chomp: true)
first_row = rows.shift
beam_tips = first_row.index("S")
beam_on(rows,  first_row.index("S"))
# @row_length = first_row.length

# go until I hit a split, then recurse from there: so need remaining rows. Go until hit a split, recurse, keep until at end. Then that's 1


# def print_em(idx, lead, positions, glyph)
#   line = "."*@row_length
#   positions.each {|pos| line[pos] = glyph}
#   puts "#{idx.to_s.rjust(3)} #{lead.rjust(10)}: |#{line}| => #{positions}, TOTAL: #{@total_splits}"
# end

# rows.each_with_index do |row, r_idx|
#   print_em(r_idx, "Beams", beams, "|")
#   carats = (0...row.length).find_all { |i| row[i, 1] == '^' }
#   if carats == [] # none
#     next
#   end

#   print_em(r_idx, "Carats", carats, "^")

#   new_beams = []
#   beams.each do |b_idx|
#     if row[b_idx] == '^' # split
#       new_beams << b_idx-1
#       new_beams << b_idx+1
#       @total_splits += 1
#     else # don't split
#       new_beams << b_idx
#     end
#   end

#   beams = new_beams.uniq
# end


puts "Solution for Day 7, Part 2: #{@total_paths}"

# ---------------------------------------------------
# --- Part Two ---

# With your analysis of the manifold complete, you begin fixing the teleporter. However, as you open the side of the teleporter to replace the broken manifold, you are surprised to discover that it isn't a classical tachyon manifold - it's a quantum tachyon manifold.

# With a quantum tachyon manifold, only a single tachyon particle is sent through the manifold. A tachyon particle takes both the left and right path of each splitter encountered.

# Since this is impossible, the manual recommends the many-worlds interpretation of quantum tachyon splitting: each time a particle reaches a splitter, it's actually time itself which splits. In one timeline, the particle went left, and in the other timeline, the particle went right.

# To fix the manifold, what you really need to know is the number of timelines active after a single particle completes all of its possible journeys through the manifold.

# In the above example, there are many timelines. For instance, there's the timeline where the particle always went left:

# .......S.......
# .......|.......
# ......|^.......
# ......|........
# .....|^.^......
# .....|.........
# ....|^.^.^.....
# ....|..........
# ...|^.^...^....
# ...|...........
# ..|^.^...^.^...
# ..|............
# .|^...^.....^..
# .|.............
# |^.^.^.^.^...^.
# |..............

# Or, there's the timeline where the particle alternated going left and right at each splitter:

# .......S.......
# .......|.......
# ......|^.......
# ......|........
# ......^|^......
# .......|.......
# .....^|^.^.....
# ......|........
# ....^.^|..^....
# .......|.......
# ...^.^.|.^.^...
# .......|.......
# ..^...^|....^..
# .......|.......
# .^.^.^|^.^...^.
# ......|........

# Or, there's the timeline where the particle ends up at the same point as the alternating timeline, but takes a totally different path to get there:

# .......S.......
# .......|.......
# ......|^.......
# ......|........
# .....|^.^......
# .....|.........
# ....|^.^.^.....
# ....|..........
# ....^|^...^....
# .....|.........
# ...^.^|..^.^...
# ......|........
# ..^..|^.....^..
# .....|.........
# .^.^.^|^.^...^.
# ......|........

# In this example, in total, the particle ends up on 40 different timelines.

# Apply the many-worlds interpretation of quantum tachyon splitting to your manifold diagram. In total, how many different timelines would a single tachyon particle end up on?
