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

  # def ordered_list_of_golfers  #must be called on an array of Golfer objects
  #   counter = 0
  #   @golfer_hash = {}
  #   self.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
  #   golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
  # end  # ends ordered_list_of_golfers method
  

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
      puts "5 - See players scorecard"
      puts "6 - Create a new Golfer record for yourself"
      puts "7 - Add your scores"
      puts "8 - Modify a score"
      puts "9 - Delete a Golfer record"
      puts "                    or type 'exit'"
      
      # Accepts user's choice from first menu
      topmenu_response = gets.chomp
      puts "\n"
      
      # Case statement to act on their choice
      case topmenu_response.to_i
      when 1
        # The following 4 lines lists player names with TEMPORARY number ids (from which the 
        # app user will make their selection), then builds a hash with
        # those temp IDs as keys, and corrosponing Golfer Objects as values
        
        counter = 0
        golfer_hash = {}
        Golfer.all.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
        golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
        
        # UNTIL statement to retry gathering input until the user makes a valid selection      
        selection_number = 0
        until selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
          puts "Which player's score would you like to see?  Submit their corrosponding NUMBER"
          selection_number = gets.chomp
          selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
      
          
          #IF statement to reject invalid selections
          if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
            puts "------------#{selection_obj.name}'s total score was #{Golfer.total_score_by_player(selection_obj.id)}----."
          else
            puts "'#{selection_number}' is not a valid selection, try again."
          end  # ends if statement about valid player number
        end  # ends until loop about valid player number
        
        
        
      when 2
        Golfer.all.each { |golfer| puts "#{golfer.id}:  #{golfer.name} shot a #{Golfer.total_score_by_player(golfer.id)}"}
      
        
      
      when 3
        Golfer.player_with_best_score
        
        
        
      when 4
        Golfer.player_with_worst_score
        
        
        
      when 5
        # The following 4 lines lists player names with TEMPORARY number ids from which the 
        # app user will make their selection, then builds a hash with
        # those temp IDs as keys, and corrosponing Golfer Objects as values
        counter = 0
        golfer_hash = {}
        Golfer.all.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
        golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
        
        # UNTIL statement to retry gathering input until the user makes a valid selection      
        selection_number = 0
        until selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
          puts "Which player's scorecard would you like to see?  Submit their corrosponding NUMBER"
          selection_number = gets.chomp
          selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
          
          #IF statement to reject invalid selections
          if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
            Score.hole_details_with_player_strokes(selection_obj.id)
          else
            puts "'#{selection_number}' is not a valid selection, try again."
          end  # Ends if statement to reject invalid selection
        end  # ends until loop about valid player number
        
      when 6
        puts "Great!  Lets get you added!  ...but first, lets make sure you aren't already registered."
        puts "What is your name? "
        new_user_name = gets.chomp
        puts "What is your age (whole numbers only)?"
        new_user_age = gets.chomp.to_i
        Golfer.create_user(new_user_name, new_user_age)
        puts "Success!  You are registered!"
        

      when 7
        counter = 0
        golfer_hash = {}
        Golfer.all.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
        golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
        
        # UNTIL statement to retry gathering input until the user makes a valid selection      
        selection_number = 0
        until selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
          puts "Submit the NUMBER next to your name"
          selection_number = gets.chomp
          selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
          
          
          #IF statement to reject invalid selections
          if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
            Golfer.add_scores(selection_obj)
            puts "Total score for the round: #{Golfer.total_score_by_player(selection_obj.id)}"
          else
            puts "'#{selection_number}' is not a valid selection, try again."
          end  # ends if statement about valid player number
        end  # ends until loop about valid player number
        

      when 8
        counter = 0
        golfer_hash = {}
        Golfer.all.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
        golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
        
        # UNTIL statement to retry gathering input until the user makes a valid selection      
        selection_number = 0
        until selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
          puts "Submit the NUMBER next to your name"
          selection_number = gets.chomp
          selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
          
          
          #IF statement to reject invalid GOLFER TO EDIT selections
          if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
            
            score_hash = {}
            score_selection_number = 0
            # if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
            until score_selection_number.to_i > 0 && score_selection_number.to_i <= score_hash.length
              
              score_selection_objs = selection_obj.scores
              
              counter = 0
              score_hash = {}
              score_selection_objs.each { |score| counter += 1; score_hash[counter] = score.id }  
              
              
              score_hash.each { |tempid,scoreid|  puts "#{tempid}: Hole number #{selection_obj.scores.find(scoreid).hole.hole_number}, current score is #{score_selection_objs.find(scoreid).strokes}"}
              
              
              puts "Submit the LINE NUMBER of the score you'd like to change"
              score_selection_number = gets.chomp
              
                
              puts "Current stroke count = #{score_selection_objs.find(score_hash[score_selection_number.to_i]).strokes}"
              puts "What would you like to change this to?"
              new_stroke_count = gets.chomp.to_i
              
              changed_score = score_selection_objs.find(score_hash[score_selection_number.to_i])
                changed_score.strokes = new_stroke_count
                changed_score.save
                puts "Success!"
                # else  
     #   puts "That is not a valid line number, try again"
    
              end  # ends until statment about score_selection_number
            else
            puts "'#{selection_number}' is not a valid selection, try again."
          end  # ends if statement about valid player number
        end  # ends until loop about valid player number
        
      when 9
        # The following 4 lines lists player names with TEMPORARY number ids (from which the 
        # app user will make their selection), then builds a hash with
        # those temp IDs as keys, and corrosponing Golfer Objects as values
        
        counter = 0
        golfer_hash = {}
        Golfer.all.each { |golfer| counter += 1; golfer_hash[counter] = golfer.name }
        golfer_hash.each { |tempnumber, golfername| puts "#{tempnumber}:  #{golfername}"}
        
        # UNTIL statement to retry gathering input until the user makes a valid selection      
        selection_number = 0
        until selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
          puts "Which Golfer Record would you like to delete?  Submit their corrosponding NUMBER"
          selection_number = gets.chomp
          selection_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
      
          
          #IF statement to reject invalid selections
          if selection_number.to_i > 0 && selection_number.to_i <= golfer_hash.length
                #Gather deleted golfer's object details and delete from Golfer table
                  deleted_obj = selection_obj.destroy
                  puts "\n Golfer #{deleted_obj.name} DELETED"
                #delete scores from the deleted golfer
                Score.where(golfer_id: deleted_obj.id).each { |obj| obj.delete}
                puts " scores also deleted"
          else
            puts "'#{selection_number}' is not a valid selection, try again."
          end  # ends if statement about valid player number
        end  # ends until loop about valid player number
        
        
        

      else  # ELSE FOR CASE STATEMENT
        # If statement to reject invalid top_menu selections and delay acting on a top_menu 'exit' selection
        # This option cant be a typical case "when" condition since the only valid selections are integers
        if topmenu_response.downcase == "exit"
        else
          puts "'#{topmenu_response}' is not a valid selection!"
        end  # ends if statement
      
      
      end  # ends CASE STATEMENT
      
      # If statement to retain top_menu 'exit' selection or ask user if they want to restart
      if 
        topmenu_response.downcase == "exit"
      else
        puts "\n hit <enter> start over, or 'exit' to exit"
        topmenu_response = gets.chomp
      end  # ends if statement
    end  # ends until loop

    # User chooses to exit the application 
    random_farewell_greeting
  end  # ends call method
  
  
  



  
end  # ends GolferApp
