require 'pry'
class Golfer < ActiveRecord::Base

  has_many :scores
  has_many :holes, through: :scores

  def self.create_user(name, age, player_handicap=nil)
    golfer = self.new
    golfer.name = name
    golfer.age = age
    if Golfer.find_by(name: name)
      puts "Looks like you are already registered!"
    else
      golfer.save
    end  # ends if Golfer.find_by loop
  end  # ends self.create method


  def self.total_score_by_player(golferid)
    Score.where(golfer_id: golferid).sum(:strokes)
  end  # ends self.total_score_by_player method

  def self.player_with_best_score
    winner = Score.group(:golfer_id).sum(:strokes).min_by {|k,v| v}
    puts "#{Golfer.find(winner[0]).name} won with a score of #{winner[1]}"
  end  # ends self.top_score method

  def self.player_with_worst_score
    loser = Score.group(:golfer_id).sum(:strokes).max_by {|k,v| v}
    puts "#{Golfer.find(loser[0]).name} won the 'Sean Vesey' award with the worst score of #{loser[1]}"
  end  # ends self.top_score method

  def self.add_scores(user)
    #binding.pry
    holenum = 0
    until holenum >= 18
      holenum += 1
      puts "What did you shoot on hole #{holenum}?"
      shots = gets.chomp.to_i
      Score.add_score_for_user(user, holenum, shots)
    end  # ends until loop
  end  # ends add_scores method


end  # end Golfer class
