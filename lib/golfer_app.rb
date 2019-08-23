require 'pry'
require 'terminal-table'
class GolferApp
  


  ## The below line hides all DB Call details
  ActiveRecord::Base.logger = nil

  def random_welcome_greeting
    greetingsarr = ["Hello!", "Welcome!", "FORE!!!!!"]
    puts "\n" + greetingsarr.sample + "\n"
  end

  def random_farewell_greeting
    greetingsarr = ["Goodbye!", "Thanks for using!", "See you at the 19th hole!"]
    puts "\n" + greetingsarr.sample + "\n"
  end

  def call
    random_welcome_greeting

    # The following 2 lines make the app run until the user chooses to 'exit'
    topmenu_response = ""
    until topmenu_response.downcase == "exit" do
      
      # Primary Menu of choices presented to the user      
      puts "\n Select from the below:"
      puts "1 - See total Score for a single player from an Event"
      puts "2 - See Full Scorecard for an Event"
      puts "3 - See the WINNING player and stroke count from Event"
      puts "4 - See the biggest LOSER and stroke count from Event"
      puts "5 - See player's scorecard from Event"
      puts "6 - Create a new Golfer record for yourself"
      puts "7 - Add your scores to Event"
      puts "8 - Modify a score"
      puts "9 - Delete a Golfer record" 
      puts "10 - Book Tee Time"
      puts "11 - Admin Tools"
      puts "                    or type 'exit'"
      
      # Accepts user's choice from first menu
      topmenu_response = gets.chomp
      puts "\n"
      
      # Case statement to act on their choice
      case topmenu_response.downcase
        
      when "1"  # Top menu response = "1 - See total score for a single player from an event"

        golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Golfer.all)
        puts "Which player's score would you like to see?  Submit their corrosponding NUMBER"
          selection_number = gets.chomp    
        selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)
        golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
  
        # builds the events hash of all events the chosen Golfer has participated in
        events_hash = Event.prints_list_of_events_for_golfer_returning_events_hash(golfer_obj)
      
        puts "Which event do you want scores for?  Submit the corrosponding NUMBER"
          selection_number = gets.chomp    
        selection_number = Event.verifies_valid_selection_else_retry(selection_number,events_hash)
        event_obj = Event.find_by(name: events_hash[selection_number.to_i])   

        #Prints the Selected user's score for the selected event
        puts "------------#{golfer_obj.name}'s total score was #{golfer_obj.total_score_by_player_per_event(event_obj)}----."

      when "2"   # Top menu response = "2 - See ALL scores for an Event"
        event_obj = Event.list_registered_events_for_selection_with_custom_message("Which event do you want to see all scores for?")
        event_golfers_arr = Golfer.gather_array_of_all_golfers_participating_in_an_event(event_obj)
        Score.full_scorecard_for_event_and_player_or_players(event_golfers_arr, event_obj)
        Golfer.player_with_best_score(event_obj)

      when "3"  # Top menu response = "3 - See the WINNING player and stroke count for an Event"
        event_obj = Event.list_registered_events_for_selection_with_custom_message("Which event do you want the winning score for?")
        Golfer.player_with_best_score(event_obj)
        
      when "4"  # Top menu response = "4 - See the biggers LOSER and stroke count for an event"
        event_obj = Event.list_registered_events_for_selection_with_custom_message("Which event do you want the losing score for?")
        Golfer.player_with_worst_score(event_obj)
        
      when "5"  # Top menu response = "5 - See player's scorecard for Event"
        event_obj = Event.list_registered_events_for_selection_with_custom_message("Which event do you want to see a player scorecard for?")
        event_golfers_arr = Golfer.gather_array_of_all_golfers_participating_in_an_event(event_obj)
        golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(event_golfers_arr )

        puts "Which player's scorecard would you like to see?  Submit their corrosponding NUMBER"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)

        golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])

        #Below is the basic printout of a user's scorecard
        #Score.hole_details_with_player_strokes_for_event(golfer_obj, event_obj)

        ##This is the start point for building the timecard in a grid
        Score.full_scorecard_for_event_and_player_or_players(golfer_obj, event_obj)

      when "6" # Top menu response = "6 - Create a new Golfer record for yourself"
        Golfer.new_golfer_verify_and_save
        
      when "7"  # Top menu response = "Add your scores"
        golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Golfer.all)
       
        puts "Submit the NUMBER next to your name"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)
        golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])


        event_obj = Event.list_events_user_is_registered_for_with_custom_message(golfer_obj,"What event would you like to add scores to?")
        valid_user_event_combo =  EventParticipant.where(event_id: event_obj.id, golfer_id: golfer_obj.id)
        golfer_obj.add_scores(event_obj)
        puts "Total score for the round: #{golfer_obj.total_score_by_player_per_event(event_obj)}"
          

      when "8"  # Top menu response = "Modify a score"
        
        golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Golfer.all)

        puts "Submit the NUMBER next to your name"
        selection_number = gets.chomp

        selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)
        golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])

        events_hash = Event.prints_list_of_events_for_golfer_returning_events_hash(golfer_obj)
        puts "Which event do you want scores for?  Submit the corrosponding NUMBER"
          selection_number = gets.chomp    
        selection_number = Event.verifies_valid_selection_else_retry(selection_number,events_hash)
        event_obj = Event.find_by(name: events_hash[selection_number.to_i])   

        counter = 0
        score_hash = {}
        arr_score_objs_for_golfer_and_event = Score.where(golfer_id: golfer_obj, event_id: event_obj)
        arr_score_objs_for_golfer_and_event.each { |score| counter += 1; score_hash[counter] = score.id } 

        # Prints all the selected users scores with corrosponding temporary identifier
        score_hash.each { |tempid,scoreid|  puts "#{tempid}: Hole number #{golfer_obj.scores.find(scoreid).hole.hole_number}, current score is #{arr_score_objs_for_golfer_and_event.find(scoreid).strokes}"}
        
        puts "Submit the LINE NUMBER of the score you'd like to change"
        score_selection_number = gets.chomp
        score_selection_number = Score.verifies_valid_selection_else_retry(score_selection_number, score_hash)

        # while score_selection_number.to_i <= 0 || score_selection_number.to_i > score_hash.length
        #   puts "'#{score_selection_number}' is not a valid selection, try again."
        #   score_selection_number = gets.chomp
        # end  # ends while loop to make user picked a valid score to change

        score_obj_to_change = arr_score_objs_for_golfer_and_event.find(score_hash[score_selection_number.to_i])
        
        puts "Current stroke count = #{score_obj_to_change.strokes}"
        puts "What would you like to change this to?"
        new_stroke_count = gets.chomp.to_i

        Score.change_and_save_score(score_obj_to_change, new_stroke_count)
  
      when "9"  # Top menu response = "Delete a Golfer record"
        golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Golfer.all)
        
        puts "Which Golfer Record would you like to delete?  Submit their corrosponding NUMBER"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)
        
        golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
        Golfer.delete_golfer_and_scores_and_eventparticipants(golfer_obj)

      when "10"  # Top menu response = "Schedule tee time!"
        course_hash = Course.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Course.all)
        puts "At which Course would you like to schedule a tee-time?"
        selection_number = gets.chomp
        selection_number = Course.verifies_valid_selection_else_retry(selection_number,course_hash)

        course_obj = Course.find_by(name: course_hash[selection_number.to_i])
        system("open", course_obj.schedule_tee_time)



      when "11"  # Top menu response = "Admin Tools"
        puts "Select an admin function"
        puts "1 - Add course and holes"
        puts "2 - Create an event"
        puts "3 - Add golfers to event"
        puts "4 - Delete an event"
        puts "5 - Add random scores for golfer event combo"

        puts "\n"

        admin_menu_selection = gets.chomp

        case admin_menu_selection

        when "1"
          new_course = Course.create_course
          new_course.add_holes

        when "2" #  Admin Menu - "Create an Event"
          new_event = Event.create_event

        when "3"
          # Let user declare what event that want to add Golfers to
          event_obj = Event.list_registered_events_for_selection_with_custom_message("Which event do you want to add golfers to?")
          EventParticipant.add_participants_to_event(event_obj)
          
        when "4"    # Admin menu - Delete and Event
          event_obj_to_delete = Event.list_registered_events_for_selection_with_custom_message(custom_message="Select the Event you'd like to delete")
          deleted_event_obj = event_obj_to_delete.destroy
          EventParticipant.delete_objects_associated_with_deleted_event_object(deleted_event_obj)
          Score.delete_objects_associated_with_deleted_event_object(deleted_event_obj)
          puts "Deleted event, and associated EventParticipant and Score objects"

        when "5"   #   Admin Menu - Add random scores for golfer event combo
          event_obj = Event.list_registered_events_for_selection_with_custom_message(custom_message="What event are you adding these random scores to?")
          arr_of_golfers_from_event = Golfer.gather_array_of_all_golfers_participating_in_an_event(event_obj)
          golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(arr_of_golfers_from_event)

       
          puts "Submit the NUMBER next to your name"
          selection_number = gets.chomp
          selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)
          golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
          #event_obj = Event.list_events_user_is_registered_for_with_custom_message(golfer_obj,"What event would you like to add scores to?")
          valid_user_event_combo =  EventParticipant.where(event_id: event_obj.id, golfer_id: golfer_obj.id)
          Golfer.add_random_scores(golfer_obj, event_obj)

        else  # ELSE FOR ADMIN MENU CASE STATEMENT

        end  # ENDS ADMIN MENU CASE STATEMENT

      when "exit"


      else  #ELSE FOR TOP MENU CASE STATEMENT
        puts "'#{topmenu_response}' is not a valid selection!"

      end  # ends CASE TOP MENU STATEMENT
  # If statement to retain top_menu 'exit' selection or ask user if they want to restart
      if topmenu_response.downcase == "exit"
      else
        puts "\n hit <enter> to go to the Main Menu, or 'exit' to exit"
        topmenu_response = gets.chomp
      end  # ends if statement
    end  # ends until loop

    # User chooses to exit the application 
    random_farewell_greeting
  end  # ends call method
  
end  # ends GolferApp
