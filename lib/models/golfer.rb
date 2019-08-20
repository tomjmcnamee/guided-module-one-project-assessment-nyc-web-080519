require 'pry'
class Golfer < ActiveRecord::Base

  has_many :scores
  has_many :holes, through: :scores

  def self.verifies_valid_golfer_selection_else_retry(selection,hash) 
    while selection.to_i <= 0 || selection.to_i > hash.length do
      puts "'#{selection}' is not a valid selection, try again."
      selection = gets.chomp
    end 
    selection
  end  # ends verifies_valid_golfer_selection_else_retry method


  def self.new_golfer_verify_and_save
    puts "Lets get you added!"
    puts "...but first, lets make sure you aren't already registered."
    puts "What is your name? "
      new_user_name = gets.chomp
    puts "What is your age (whole numbers only)?"
      new_user_age = gets.chomp.to_i
    newgolfer = self.new
    newgolfer.name = new_user_name
    newgolfer.age = new_user_age
    if Golfer.find_by(name: newgolfer.name)
      puts "Looks like you are already registered!"
    else
      newgolfer.register
    end  # ends if Golfer.find_by loop
  end  # ends new_golfer_instance

  def register
      self.save
      puts "Success!  You are registered!"
  end  # ends self.create method


  def self.total_score_by_player(golferobj)
    Score.where(golfer_id: golferobj).sum(:strokes)
  end  # ends self.total_score_by_player method

  def self.player_with_best_score
    winner = Score.group(:golfer_id).sum(:strokes).min_by {|k,v| v}
    puts "#{Golfer.find(winner[0]).name} won with a score of #{winner[1]}"
  end  # ends self.top_score method

  def self.player_with_worst_score
    loser = Score.group(:golfer_id).sum(:strokes).max_by {|k,v| v}
    puts "#{Golfer.find(loser[0]).name} won the 'Sean Vesey' award with the worst score of #{loser[1]}"
  end  # ends self.top_score method

  def self.add_scores(user_obj)
    #binding.pry
    holenum = 0
    until holenum >= 18
      holenum += 1
      puts "What did you shoot on hole #{holenum}?"
      shots = gets.chomp.to_i
      Score.add_score_for_user(user_obj, holenum, shots)
    end  # ends until loop
  end  # ends add_scores method

# The following method lists player names with TEMPORARY number ids (from which the 
# app user will make their selection), then builds a hash with
# those temp IDs as keys, and corrosponing Golfer Objects as values
  def self.print_list_of_valid_golfers(golfer_obj_arr)
    counter = 0
    golfer_hash = {}
    golfer_obj_arr.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
    golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
    golfer_hash
  end  # Ends self.print_list_of_valid_golfers 

  def self.delete_golfer_and_scores(golfer_obj)
    deleted_obj = golfer_obj.destroy
    puts "\n Golfer #{deleted_obj.name} DELETED"
    Score.where(golfer_id: deleted_obj.id).each { |obj| obj.delete}
    puts " scores also deleted"
  end



end  # end Golfer class
