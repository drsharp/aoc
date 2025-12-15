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
    @last_box_a
    @last_box_b
  end

  def multiply_last_two_xes
    @last_box_a.point.x * @last_box_b.point.x
  end

  def wire_up(box_a, box_b)
    @last_box_a = box_a
    @last_box_b = box_b

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
  if boxes.all?(&:in_circuit?) && @circuit_manager.circuits.length == 1
    break
  end
end

puts "Solution for Day 8, Part 2: #{@circuit_manager.multiply_last_two_xes}"

# ---------------------------------------------------
# --- Part Two ---

# The Elves were right; they definitely don't have enough extension cables. You'll need to keep connecting junction boxes together until they're all in one large circuit.

# Continuing the above example, the first connection which causes all of the junction boxes to form a single circuit is between the junction boxes at 216,146,977 and 117,168,530. The Elves need to know how far those junction boxes are from the wall so they can pick the right extension cable; multiplying the X coordinates of those two junction boxes (216 and 117) produces 25272.

# Continue connecting the closest unconnected pairs of junction boxes together until they're all in the same circuit. What do you get if you multiply together the X coordinates of the last two junction boxes you need to connect?
