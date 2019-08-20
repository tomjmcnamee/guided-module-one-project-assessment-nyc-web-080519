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
      puts "1 - See total score for a single player"
      puts "2 - See ALL scores"
      puts "3 - See the WINNING player and stroke count"
      puts "4 - See the biggest LOSER and stroke count"
      puts "5 - See player's scorecard"
      puts "6 - Create a new Golfer record for yourself"
      puts "7 - Add your scores"
      puts "8 - Modify a score"
      puts "9 - Delete a Golfer record"
      puts "                    or type 'exit'"
      
      # Accepts user's choice from first menu
      topmenu_response = gets.chomp
      puts "\n"
      
      # Case statement to act on their choice
      case topmenu_response.downcase
        
      when "1"  # Top menu response = "1 - See total score for a single player"
        golfer_hash = Golfer.print_list_of_valid_golfers(Golfer.all)

        puts "Which player's score would you like to see?  Submit their corrosponding NUMBER"
        selection_number = gets.chomp    
        
        # Verifies golfer selection is valid, else asks user to try again 
        selection_number = Golfer.verifies_valid_golfer_selection_else_retry(selection_number,golfer_hash)

        # Prints scores for all users
        selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
        puts "------------#{selection_obj.name}'s total score was #{Golfer.total_score_by_player(selection_obj)}----."

      when "2"   # Top menu response = "2 - See ALL scores"
        Golfer.all.each { |golfer| puts "#{golfer.name} shot a #{Golfer.total_score_by_player(golfer)}"}
      
      when "3"  # Top menu response = "3 - See the WINNING player and stroke count"
        Golfer.player_with_best_score
        
      when "4"  # Top menu response = "4 - See the biggers LOSER and stroke count"
        Golfer.player_with_worst_score
        
      when "5"  # Top menu response = "5 - See player's scorecard"
        golfer_hash = Golfer.print_list_of_valid_golfers(Golfer.all)

        puts "Which player's scorecard would you like to see?  Submit their corrosponding NUMBER"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_golfer_selection_else_retry(selection_number,golfer_hash)

        
        selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
        Score.hole_details_with_player_strokes(selection_obj)

      when "6" # Top menu response = "6 - Create a new Golfer record for yourself"
        Golfer.new_golfer_verify_and_save
        
      when "7"  # Top menu response = "Add your scores"
        golfer_hash = Golfer.print_list_of_valid_golfers(Golfer.all)
       
        puts "Submit the NUMBER next to your name"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_golfer_selection_else_retry(selection_number,golfer_hash)

        selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
        Golfer.add_scores(selection_obj)
        puts "Total score for the round: #{Golfer.total_score_by_player(selection_obj)}"
          

      when "8"  # Top menu response = "Modify a score"
        
        golfer_hash = Golfer.print_list_of_valid_golfers(Golfer.all)

        puts "Submit the NUMBER next to your name"
        selection_number = gets.chomp

        selection_number = Golfer.verifies_valid_golfer_selection_else_retry(selection_number,golfer_hash)

        selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])

        counter = 0
        score_hash = {}
        score_selection_objs = selection_obj.scores
        score_selection_objs.each { |score| counter += 1; score_hash[counter] = score.id } 
        
        # Prints all the selected users scores with corrosponding temporary identifier
        score_hash.each { |tempid,scoreid|  puts "#{tempid}: Hole number #{selection_obj.scores.find(scoreid).hole.hole_number}, current score is #{score_selection_objs.find(scoreid).strokes}"}
        
        puts "Submit the LINE NUMBER of the score you'd like to change"
        score_selection_number = gets.chomp

        while score_selection_number.to_i <= 0 || score_selection_number.to_i > score_hash.length
          puts "'#{score_selection_number}' is not a valid selection, try again."
          score_selection_number = gets.chomp
        end  # ends while loop to make user picked a valid score to change

        score_obj_to_change = score_selection_objs.find(score_hash[score_selection_number.to_i])
        
        puts "Current stroke count = #{score_obj_to_change.strokes}"
        puts "What would you like to change this to?"
        new_stroke_count = gets.chomp.to_i

        Score.change_and_save_score(score_selection_objs,score_hash,score_selection_number,new_stroke_count)
  
      when "9"  # Top menu response = "Delete a Golfer record"
        golfer_hash = Golfer.print_list_of_valid_golfers(Golfer.all)
        
        puts "Which Golfer Record would you like to delete?  Submit their corrosponding NUMBER"
        selection_number = gets.chomp
        selection_number = Golfer.verifies_valid_golfer_selection_else_retry(selection_number,golfer_hash)
        
        selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
        Golfer.delete_golfer_and_scores(selection_obj)

      when "exit"

      else  #ELSE FOR CASE STATEMENT
        puts "'#{topmenu_response}' is not a valid selection!"

      end  # ends CASE STATEMENT
  # If statement to retain top_menu 'exit' selection or ask user if they want to restart
      if topmenu_response.downcase == "exit"
      else
        puts "\n hit <enter> start over, or 'exit' to exit"
        topmenu_response = gets.chomp
      end  # ends if statement
    end  # ends until loop

    # User chooses to exit the application 
    random_farewell_greeting
  end  # ends call method
  
end  # ends GolferApp
