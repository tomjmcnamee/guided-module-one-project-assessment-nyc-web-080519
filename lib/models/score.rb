require 'pry'
class Score < ActiveRecord::Base
  extend ListUtilities
  extend DeleteUtilities

  belongs_to :hole
  belongs_to :golfer
  belongs_to :event



  def self.hole_details_with_player_strokes_for_event(golfer_obj, event_obj)
    # binding.pry
    arr_golfers_scores_from_event = Score.where(golfer_id: golfer_obj, event_id: event_obj)
    puts "#{event_obj.name} - Scorecard for #{golfer_obj.name}"
    arr_golfers_scores_from_event.each do |score_obj|
      hole_number = score_obj.hole.hole_number
      par = score_obj.hole.par
      puts "Hole #{hole_number}(par #{par}): #{score_obj.strokes}"
    end  #ends each
  end #  ends self.hole_details_with_player_strokes

  def self.add_score_for_user(golfer_obj, hole, stroke_ct, event_obj)
      new_score = Score.new
      new_score.golfer_id = golfer_obj.id 
      new_score.hole_id = hole 
      new_score.strokes = stroke_ct
      new_score.event_id = event_obj.id
      new_score.save
  end # ends add_score_to_user method


  def self.change_and_save_score(golfers_score_object,new_stroke_count)
    golfers_score_object.strokes = new_stroke_count
    golfers_score_object.save
    puts "Success!"
  end  # ends 
  

end  # end Score class
