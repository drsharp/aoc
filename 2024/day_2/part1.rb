#!/usr/bin/env ruby

def is_safe?(line)
  values = line.split.map(&:to_i)

  return false if values[0] == values[1] # bail if the first two match
  values.reverse! if values[1] < values[0] # invert if it's a decrease
  print "Checking: #{values} => "

  # now walk through. next should be with 1-3 of previous
  nvalue = values.shift

  while !values.empty? do
    print "."
    pvalue = nvalue
    nvalue = values.shift
    distance = nvalue - pvalue
    if !distance.between?(1,3)
      puts " => NO"
      return false
    end
  end

  puts " => YES"
  return true
end

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

reports = File.readlines(ARGV.first, chomp: true)

safe_count = 0
reports.each do |report|
  safe_count += 1 if is_safe?(report)
end

puts "\nSolution for Day 2 part 1: Total Safe: #{safe_count}"
