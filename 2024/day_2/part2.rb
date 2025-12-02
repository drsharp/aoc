#!/usr/bin/env ruby

def is_safe?(report_as_array, leading=false)
  values = report_as_array.map(&:to_i)

  return false if values[0] == values[1] # bail if the first two match
  values.reverse! if values[1] < values[0] # invert if it's a decrease
  print "#{leading ? "\t" : "" }is_safe? #{values} => "

  # now walk through. next should be with 1-3 of previous
  nvalue = values.shift

  while !values.empty? do
    pvalue = nvalue
    nvalue = values.shift
    distance = nvalue - pvalue
    if !distance.between?(1,3)
      puts "NO"
      return false
    end
  end

  puts "YES"
  return true
end

def still_safe?(report_as_array)
  reports = report_as_array.map(&:to_i)
  reports.each_with_index do |_, index|
    array_minus_element = reports[0...index] + reports[index + 1..-1]
    return true if is_safe?(array_minus_element, true)
  end
  return false # none was unsafe?
end

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

reports = File.readlines(ARGV.first, chomp: true)

safe_count = 0
reports.each do |report|
  puts "Checking... #{report}"
  if is_safe?(report.split)
    puts "#{report} is SAFE"
    safe_count += 1
  elsif still_safe?(report.split)
    puts "#{report} is STILL SAFE"
    safe_count += 1
  end
end

puts "\nSolution for Day 2 part 2: Total Safe: #{safe_count}"
