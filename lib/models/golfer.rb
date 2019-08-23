require 'pry'

class Golfer < ActiveRecord::Base
  extend ListUtilities

  has_many :scores
  has_many :holes, through: :scores



  def self.new_golfer_verify_and_save
    puts "Lets get you added!"
    puts "...but first, lets make sure you aren't already registered."
    puts "What is your name? "
      new_user_name = gets.chomp
    newgolfer = self.new
    newgolfer.name = new_user_name
    if Golfer.find_by(name: newgolfer.name)
      puts "Looks like you are already registered!"
    else
      puts "What is your age (whole numbers only)?"
      new_user_age = gets.chomp.to_i
      newgolfer.age = new_user_age
      newgolfer.register
      puts "Success!  You are registered!"
    end  # ends if Golfer.find_by loop
  end  # ends new_golfer_instance

  def register
      self.save
      
  end  # ends self.create method


  def total_score_by_player_per_event(event_obj)
    
    Score.where(golfer_id: self, event_id: event_obj).sum(:strokes)
  end  # ends self.total_score_by_player method

  def self.player_with_best_score(event_obj)
    winner = Score.where(event_id: event_obj).group(:golfer_id).sum(:strokes).min_by {|k,v| v}
    if Score.where(event_id: event_obj).group(:golfer_id).sum(:strokes).select {|k,v| v == winner[1]}.length > 1
      winner_count = Score.where(event_id: event_obj).group(:golfer_id).sum(:strokes).select {|k,v| v == winner[1]}.length
      puts "THERE WAS A TIE! #{winner_count} Golfers shot a #{winner[1]}"
      tieing_player_ids = Score.where(event_id: event_obj).group(:golfer_id).sum(:strokes).select {|k,v| v == winner[1]}.keys
      tieing_player_ids.each{|golfer_id| puts "      #{Golfer.find(golfer_id).name}"}
    else

      puts "#{Golfer.find(winner[0]).name} won with a score of #{winner[1]}"
    end  # Ends if
  end  # ends self.top_score method

  def self.player_with_worst_score(event_obj)
    loser = Score.where(event_id: event_obj).group(:golfer_id).sum(:strokes).max_by {|k,v| v}
    puts "#{Golfer.find(loser[0]).name} was the big loser with a score of #{loser[1]}"
  end  # ends self.top_score method

  def add_scores(event_obj)
    case event_obj.front_back_all
    when "Front 9"
      holenum = 0
      stop_at = 9
    when "Back 9"
      holenum = 9
      stop_at = 18
    when "All 18"
      holenum = 0
      stop_at = 18
    end # ends CASE Statement event_obj.front_back_all

    until holenum >= stop_at
      holenum += 1
      puts "What did you shoot on hole #{holenum}?"
      shots = gets.chomp.to_i
      Score.add_score_for_user(self, holenum, shots, event_obj)
    end  # ends until loop
    
  end  # ends add_scores method


  def self.add_random_scores(user_obj, event_obj)

    case event_obj.front_back_all
    when "Front 9"
      holenum = 0
      stop_at = 9
    when "Back 9"
      holenum = 9
      stop_at = 18
    when "All 18"
      holenum = 0
      stop_at = 18
    end # ends CASE Statement event_obj.front_back_all
    
    until holenum >= stop_at
      holenum += 1
      shots = rand(3..10)
      Score.add_score_for_user(user_obj, holenum, shots, event_obj)
    end  # ends until loop
  end  # ends add_random_scores method

  def self.delete_golfer_and_scores_and_eventparticipants(golfer_obj)
    deleted_obj = golfer_obj.destroy
    puts "\n Golfer #{deleted_obj.name} DELETED"
    Score.where(golfer_id: deleted_obj.id).each { |obj| obj.delete}
    #EventParticipent.where(golfer_id: deleted_obj.id).each { |obj| obj.delete }
    puts " scores also deleted"
  end

  def self.gather_array_of_all_golfers_participating_in_an_event(event_obj)
    event_golfers_arr = []
    EventParticipant.where(event_id: event_obj.id).each { |obj| event_golfers_arr << obj.golfer }
    event_golfers_arr
  end  # ends gather_array_of_all_golfers_participating_in_an_event method

  def build_golfer_array_of_strokes(event_obj)
      arr_golfers_score_objs_from_event = Score.where(golfer_id: self, event_id: event_obj)
      arr_of_strokes = []
      arr_golfers_score_objs_from_event.each { |scoreobj| arr_of_strokes << scoreobj.strokes }
      arr_of_strokes
  end 


end  # end Golfer class
