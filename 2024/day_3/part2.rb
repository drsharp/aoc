#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

data = File.read(ARGV.first, chomp: true)

puts "DATA=#{data}"
computed = 0

muls = data.scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/)
enabled = true

muls.each do |a_mul|
  if a_mul == "do()"
    puts "DO!"
    enabled = true
  elsif a_mul == "don't()"
    puts "DON'T!"
    enabled = false
  else
    a_mul.scan(/\((\d+),(\d+)\)/) do |first, second|
      puts "First: #{first}, Second: #{second}. Multiply? #{enabled}"
      computed += (first.to_i * second.to_i) if enabled
    end
  end
end

puts "\nSolution for Day 3 part 2: Total Computed: #{computed}"
