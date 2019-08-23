require 'pry'
class Score < ActiveRecord::Base
  extend ListUtilities
  extend DeleteUtilities

  belongs_to :hole
  belongs_to :golfer
  belongs_to :event

  def self.full_scorecard_for_event_and_player_or_players(golfer_obj_or_arr, event_obj)
    ## This if statment makes sure the row looping ALWAYS starts with an array
    arr_of_golfer_objects = []
    if golfer_obj_or_arr.class == Array
      arr_of_golfer_objects = golfer_obj_or_arr
    else
      arr_of_golfer_objects << golfer_obj_or_arr
    end
    #This builds the HEADER for the table
    case event_obj.front_back_all  
    when "Front 9"
      table = Terminal::Table.new do |t|
        t << [{:value => "Hole:", :alignment => :right},1,2,3,4,5,6,7,8,9,"Total"]
      end
    when "Back 9"
      table = Terminal::Table.new do |t|
        t << [{:value => "Hole:", :alignment => :right},10,11,12,13,14,15,16,17,18,"Total"]
      end
    when "All 18"
      table = Terminal::Table.new do |t|
        t << [{:value => "Hole:", :alignment => :right},1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,"Total"]
      end
    end  ## Ends Case Statement about Which Holes this event is for

    arr_of_golfer_objects.each do |golfer_obj|
      arr_of_strokes = golfer_obj.build_golfer_array_of_strokes(event_obj)
      #This case statement Populates each row
      case event_obj.front_back_all
      when "Front 9"
        self.add_player_row_to_scorecard_table_for_9_holes(golfer_obj,arr_of_strokes,table)
      when "Back 9"
        self.add_player_row_to_scorecard_table_for_9_holes(golfer_obj,arr_of_strokes,table)
      when "All 18"
        self.add_player_row_to_scorecard_table_for_18_holes(golfer_obj,arr_of_strokes,table)
      end  ## Ends Case Statement to build the Table Rows
    end  # ENDS arr_of_golfer_objects.each loop
    puts table
  end  # ends full_scorecard_for_event_and_player method

  def self.add_player_row_to_scorecard_table_for_9_holes(golfer_obj,arr_of_scores,table)
    table << :separator
    table << [golfer_obj.name, arr_of_scores[0],arr_of_scores[1],arr_of_scores[2],arr_of_scores[3],arr_of_scores[4],arr_of_scores[5],arr_of_scores[6],arr_of_scores[7],arr_of_scores[8],arr_of_scores.sum]
  end   # ends add_player_row_to_table_for_9_holes

  def self.add_player_row_to_scorecard_table_for_18_holes(golfer_obj,arr_of_scores,table)
    table << :separator
    table << [golfer_obj.name, arr_of_scores[0],arr_of_scores[1],arr_of_scores[2],arr_of_scores[3],arr_of_scores[4],arr_of_scores[5],arr_of_scores[6],arr_of_scores[7],arr_of_scores[8],arr_of_scores[9],arr_of_scores[10],arr_of_scores[11],arr_of_scores[12],arr_of_scores[13],arr_of_scores[14],arr_of_scores[15],arr_of_scores[16],arr_of_scores[17],arr_of_scores.sum]
  end   # ends add_player_row_to_table_for_18_holes
  
  def self.hole_details_with_player_strokes_for_event(golfer_obj, event_obj)
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
