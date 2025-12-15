#!/usr/bin/env ruby

require "geom" # for 3D distances

if ARGV.empty?
  puts "ERROR: You must pass in the input file as the first argument!: ./part1.rb <inputfile>"
  exit
end

class Box
  attr_reader :id, :point
  attr_accessor :circuit

  def initialize(id, x,y,z)
    @circuit = nil
    @id = id
    @point = Geom::Point.new(x,y,z)
    @in_circuit = false
  end

  def in_circuit?
    @in_circuit
  end

  def add_to_circuit(circuit)
    @circuit = circuit
    @in_circuit = true
  end


  def to_s
    "Box #{@id} @ #{@point}"
  end
end

class Circuit
  def initialize(list_of_boxes)
    @wired_boxes = list_of_boxes.flatten.uniq
    @wired_boxes.each do |wired_box|
      wired_box.add_to_circuit(self)
    end
  end

  def boxes
    @wired_boxes
  end

  def add_box(box)
    @wired_boxes << box
    box.add_to_circuit(self)
  end

  def size
    @wired_boxes.size
  end

  def <=>(other_circuit)
    other_circuit.size <=> self.size
  end

  def to_s
    "Circuit: #{@wired_boxes.map(&:id)}"
  end
end

class CircuitManager
  attr_reader :circuits

  def initialize
    @circuits = []
  end

  def wire_up(box_a, box_b)
    if !box_a.in_circuit? && !box_b.in_circuit? # neither in circuit, create a new one
      @circuits << Circuit.new([box_a, box_b])
    elsif box_a.in_circuit? && !box_b.in_circuit? # a in circuit, b not in circuit. Add B to A's circuit
      box_a.circuit.add_box(box_b)
    elsif !box_a.in_circuit? && box_b.in_circuit? # a not in circuit, b in circuit. Add A to B's circuit
      box_b.circuit.add_box(box_a)
    else # both are in circuits (different circuits). Join them
      old_circuit_a = box_a.circuit
      old_circuit_b = box_b.circuit
      @circuits.delete(old_circuit_a)
      @circuits.delete(old_circuit_b)
      @circuits << Circuit.new(old_circuit_a.boxes + old_circuit_b.boxes)
    end
  end
end

class DistanceBetween
  attr_reader :distance, :box_a, :box_b

  def initialize(box_a, box_b)
    @box_a = box_a
    @box_b = box_b
    @distance = box_a.point.distance_to_point(box_b.point)
  end

  def in_circuit?
    @box_a.in_circuit? || @box_b.in_circuit?
  end

  def <=>(other_distance_between)
    self.distance <=> other_distance_between.distance
  end

  def to_s
    "Between #{@box_a} => #{@box_b}"
  end
end

boxes = []
File.readlines(ARGV.first, chomp: true).each_with_index do |row, i|
  x,y,z = row.split(",").map(&:to_i)
  boxes << Box.new(i, x, y, z)
end

distances_between = []
boxes.each do |box_a|
  boxes.each do |box_b|
    next if box_b.id <= box_a.id
    distances_between << DistanceBetween.new(box_a, box_b)
  end
end

@circuit_manager = CircuitManager.new
count = 0
distances_between.sort.each do |distance|
  count += 1
  @circuit_manager.wire_up(distance.box_a, distance.box_b)
  if count == 1000
    puts "Found 1000"
    biggest_circuits = @circuit_manager.circuits.sort[0..2]
    @multipied = biggest_circuits.map(&:size).reduce(:*)
    break
  end
end

puts "Solution for Day 8, Part 1: #{@multipied}"

# ---------------------------------------------------
# --- Day 8: Playground ---

# Equipped with a new understanding of teleporter maintenance, you confidently step onto the repaired teleporter pad.

# You rematerialize on an unfamiliar teleporter pad and find yourself in a vast underground space which contains a giant playground!

# Across the playground, a group of Elves are working on setting up an ambitious Christmas decoration project. Through careful rigging, they have suspended a large number of small electrical junction boxes.

# Their plan is to connect the junction boxes with long strings of lights. Most of the junction boxes don't provide electricity; however, when two junction boxes are connected by a string of lights, electricity can pass between those two junction boxes.

# The Elves are trying to figure out which junction boxes to connect so that electricity can reach every junction box. They even have a list of all of the junction boxes' positions in 3D space (your puzzle input).

# For example:

# 162,817,812
# 57,618,57
# 906,360,560
# 592,479,940
# 352,342,300
# 466,668,158
# 542,29,236
# 431,825,988
# 739,650,466
# 52,470,668
# 216,146,977
# 819,987,18
# 117,168,530
# 805,96,715
# 346,949,466
# 970,615,88
# 941,993,340
# 862,61,35
# 984,92,344
# 425,690,689

# This list describes the position of 20 junction boxes, one per line. Each position is given as X,Y,Z coordinates. So, the first junction box in the list is at X=162, Y=817, Z=812.

# To save on string lights, the Elves would like to focus on connecting pairs of junction boxes that are as close together as possible according to straight-line distance. In this example, the two junction boxes which are closest together are 162,817,812 and 425,690,689.

# By connecting these two junction boxes together, because electricity can flow between them, they become part of the same circuit. After connecting them, there is a single circuit which contains two junction boxes, and the remaining 18 junction boxes remain in their own individual circuits.

# Now, the two junction boxes which are closest together but aren't already directly connected are 162,817,812 and 431,825,988. After connecting them, since 162,817,812 is already connected to another junction box, there is now a single circuit which contains three junction boxes and an additional 17 circuits which contain one junction box each.

# The next two junction boxes to connect are 906,360,560 and 805,96,715. After connecting them, there is a circuit containing 3 junction boxes, a circuit containing 2 junction boxes, and 15 circuits which contain one junction box each.

# The next two junction boxes are 431,825,988 and 425,690,689. Because these two junction boxes were already in the same circuit, nothing happens!

# This process continues for a while, and the Elves are concerned that they don't have enough extension cables for all these circuits. They would like to know how big the circuits will be.

# After making the ten shortest connections, there are 11 circuits: one circuit which contains 5 junction boxes, one circuit which contains 4 junction boxes, two circuits which contain 2 junction boxes each, and seven circuits which each contain a single junction box. Multiplying together the sizes of the three largest circuits (5, 4, and one of the circuits of size 2) produces 40.

# Your list contains many junction boxes; connect together the 1000 pairs of junction boxes which are closest together. Afterward, what do you get if you multiply together the sizes of the three largest circuits?
