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
# datalines = [
#   "11 12 13 14 15",
#   "21 22 23 24 25",
#   "31 32 33 34 35",
#   "41 42 43 44 45",
#   "51 52 53 54 55",
# ]
row_count = datalines.size

max_length = datalines.map(&:length).max
# max_length = 5
max_width = [max_length, row_count].max

puts "max_row = #{max_length}, row_count = #{row_count}, max_width=#{max_width}"

# build 2D array, pushing with "." at the end
dataset = []
datalines.each do |dataline|
  dataset << dataline.ljust(max_width, "-").split("")
end

# fill out any more rows if the max row length > number of rows
(max_length - row_count).times do
  dataset << ("o"*max_width).split("")
end

puts "Data: #{dataset.inspect}"

total_count = 0

# count rows
pass1count = count_matches(dataset)
puts "Pass 1 Dataset. count = #{pass1count}"
print_dataset(dataset)

# rotate and count rows
pass2dataset = dataset.transpose
pass2count = count_matches(pass2dataset)
puts "Pass 2 Data. count = #{pass2count}"
print_dataset(pass2dataset)


# build diagonal
pass3datasaet = build_diagonal_dataset(dataset)
pass3count = count_matches(pass3datasaet)
puts "Pass 3 Dataset. count = #{pass3count}"
print_dataset(pass3datasaet)

# build diagonal transposed
pass4dataset = build_diagonal_dataset(dataset.transpose, skip_first: true)
pass4count = count_matches(pass4dataset)
puts "Pass 4 Dataset. count = #{pass4count}"
print_dataset(pass4dataset)

# build diagonal transposed
pass5dataset = build_diagonal_dataset(dataset.map(&:reverse))
pass5count = count_matches(pass5dataset)
puts "Pass 5 Dataset. count = #{pass5count}"
print_dataset(pass5dataset)

# build diagonal transposed
pass6dataset = build_diagonal_dataset(dataset.map(&:reverse).transpose, skip_first: true)
pass6count = count_matches(pass6dataset)
puts "Pass 6 Dataset. count = #{pass6count}"
print_dataset(pass6dataset)

total_count = pass1count + pass2count + pass3count + pass4count + pass5count + pass6count

puts "\nSolution for Day 4 part 1: Total Computed: #{total_count}"
