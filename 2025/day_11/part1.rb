#!/usr/bin/env ruby

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

# find in reverse:
# out -> X
# out -> Y
# for each of those, now find all paths from X -> ?
#

@connection_count = 0

@count = 0
def make_connection(connection_list, next_connection)
  print "."
  if connection_list.size > 0
    possibles = connection_list.find_all{|conn| conn.first == next_connection}
    if possibles.empty?
      return
    end
    possibles.each do |connection|
      if connection.last == "you"
        puts "OUT"
        @connection_count += 1
      else
        new_list = connection_list - [connection]
        make_connection(new_list, connection.last)
      end
    end
  end
end

@connections = []
File.readlines(ARGV.first, chomp: true).each do |line|
  source,sinks = line.split(": ")
  sinks.split(" ").each do |sink|
    @connections << [sink, source]
  end
end

# puts "#{@connections}"

# out -> iii, iii -> hhh, hhh -> aaa. Done, no match
# out -> ggg, ggg -> ddd, ddd -> bbb, bbb -> you
#                         ddd -> ccc, ccc -> you
# out -> eee, eee -> ccc, ccc -> you
#             eee -> bbb, bbb -> you
# out -> fff, fff -> hhh, hhh -> aaa. Done
# out -> fff, fff -> ccc, ccc -> you


# so looping through outs:
# out -> eee
# next, loop through all cases where eee is on the right, and for each of them,


start_connections = @connections.find_all{|conn| conn.first == "out"}
start_connections.each do |connection|
  list = (@connections - [connection]).dup
  make_connection(list, connection.last)
end



puts "Solution for Day 11, Part 1: #{@connection_count}"

# ---------------------------------------------------
# --- Day 11: Reactor ---

# You hear some loud beeping coming from a hatch in the floor of the factory, so you decide to check it out. Inside, you find several large electrical conduits and a ladder.

# Climbing down the ladder, you discover the source of the beeping: a large, toroidal reactor which powers the factory above. Some Elves here are hurriedly running between the reactor and a nearby server rack, apparently trying to fix something.

# One of the Elves notices you and rushes over. "It's a good thing you're here! We just installed a new server rack, but we aren't having any luck getting the reactor to communicate with it!" You glance around the room and see a tangle of cables and devices running from the server rack to the reactor. She rushes off, returning a moment later with a list of the devices and their outputs (your puzzle input).

# For example:

# aaa: you hhh
# you: bbb ccc
# bbb: ddd eee
# ccc: ddd eee fff
# ddd: ggg
# eee: out
# fff: out
# ggg: out
# hhh: ccc fff iii
# iii: out

# Each line gives the name of a device followed by a list of the devices to which its outputs are attached. So, bbb: ddd eee means that device bbb has two outputs, one leading to device ddd and the other leading to device eee.

# The Elves are pretty sure that the issue isn't due to any specific device, but rather that the issue is triggered by data following some specific path through the devices. Data only ever flows from a device through its outputs; it can't flow backwards.

# After dividing up the work, the Elves would like you to focus on the devices starting with the one next to you (an Elf hastily attaches a label which just says you) and ending with the main output to the reactor (which is the device with the label out).

# To help the Elves figure out which path is causing the issue, they need you to find every path from you to out.

# In this example, these are all of the paths from you to out:

#     Data could take the connection from you to bbb, then from bbb to ddd, then from ddd to ggg, then from ggg to out.
#     Data could take the connection to bbb, then to eee, then to out.
#     Data could go to ccc, then ddd, then ggg, then out.
#     Data could go to ccc, then eee, then out.
#     Data could go to ccc, then fff, then out.

# In total, there are 5 different paths leading from you to out.

# How many different paths lead from you to out?
