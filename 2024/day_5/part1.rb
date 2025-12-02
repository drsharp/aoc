#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

class OrderingRule
  def initialize(before, after)
    @before = before
    @after = after
  end

  def
end

datalines = File.read(ARGV.first, chomp: true)
beforeafters, ordering = datalines.split("\n\n")

ordering_rules = {}

row_count = datalines.size

# lines,


total_count = 0

puts "\nSolution for Day 5 part 1: Total Computed: #{total_count}"
