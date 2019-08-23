class Course < ActiveRecord::Base
  extend ListUtilities
  

  has_many :holes

  def self.create_course
    new_course = Course.new
    puts "What is the course's name?"
      new_course.name = gets.chomp
    puts "What is the address?"
    new_course.address = gets.chomp
    puts "Phone number?"
    new_course.phone_number = gets.chomp
    puts "and Course Homepage URL (including the 'http(s)://www')" 
    new_course.url =  "#{gets.chomp}"
    puts "add URL for booking a tee-time"
    new_course.schedule_tee_time =  "#{gets.chomp}"
    new_course.save
    new_course
  end  # ends self.create_course method

  def add_holes
    holect = 0 
    until (1..18).include?(holect) 
      puts "How many holes does this course have?(integers only)"
      holect = gets.chomp.to_i
    end  # ends until holect loop
    holenum = 0
    until holenum >= holect
      holenum += 1
      new_hole = Hole.new
      new_hole.hole_number = holenum
      new_hole.course_id = self
      puts "HOLE #{holenum}: input distance"
      new_hole.distance = gets.chomp
      puts "HOLE #{holenum}: input handicap"
      new_hole.hole_handicap = gets.chomp
      puts "HOLE #{holenum}: input par"
      new_hole.par = gets.chomp
      new_hole.save
    end  # Ends holenum UNTIL loop
    puts "SUCCESS!  All added"
  end  # ends add_holes method


end  # end Course class
