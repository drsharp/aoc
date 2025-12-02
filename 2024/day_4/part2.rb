#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

def print_dataset(dataset)
  max_length = dataset.map(&:length).max

  puts "--" * max_length
  puts dataset.map{|row| row.join(" ")}.join("\n")
  puts "--" * max_length
end


def build_diagonal_dataset(dataset, skip_first: false)

  # build diagonal strings:
  colx = 0
  diagonal = []
  diagstrings = []

  row_count = dataset.count
  max_length = dataset.map(&:length).max
  max_size = [max_length, row_count].max

  diag_strings = []
  max_size.times do |rowx|
    onepass = []
    max_size.times do |colx|
      char_at_spot = dataset[colx][rowx] || "*"
      onepass.push(char_at_spot)
      # puts "reading data[#{colx}][#{rowx}]: #{char_at_spot}"
      rowx += 1
    end
    diag_strings << onepass unless skip_first
    skip_first = false # force it to false for the rest
  end
  diag_strings
end

def count_matches(data)
  count = 0
  data.each do |row|
    count += row.join.scan(/XMAS/).count # need to do these separately
    count += row.join.scan(/SAMX/).count # because they could overlap X or S
  end
  count
end

datalines = File.readlines(ARGV.first, chomp: true)
row_count = datalines.size

max_length = datalines.map(&:length).max
max_width = [max_length, row_count].max

puts "max_row = #{max_length}, row_count = #{row_count}, max_width=#{max_width}"

# build 2D array, pushing with "." at the end
dataset = []
datalines.each do |dataline|
  dataset << dataline.ljust(max_width, ".").split("")
end

# fill out any more rows if the max row length > number of rows
(max_length - row_count).times do
  dataset << ("."*max_width).split("")
end

# puts "Data: #{dataset.inspect}"
total_count = 0

(1..max_width-2).each do |row|
  (1..max_width-2).each do |col|
    puzzle_char = dataset[row][col]
    if puzzle_char == "A"
      # it's an X if:
      # 1:
      ul = dataset[row-1][col-1]
      ur = dataset[row-1][col+1]
      ll = dataset[row+1][col-1]
      lr = dataset[row+1][col+1]
      if (ul + lr == "SM" || ul + lr == "MS") && (ur + ll == "SM" || ur + ll == "MS")
        total_count += 1
      end
    end
  end
end

puts "\nSolution for Day 4 part 2: Total Computed: #{total_count}"
