class EventParticipant < ActiveRecord::Base
  extend DeleteUtilities

  belongs_to :event
  belongs_to :golfer

  def self.creates_new_event_participants_record(eventid, golferid)
    new_EP_record = EventParticipant.new
    new_EP_record.event_id = eventid
    new_EP_record.golfer_id = golferid
    new_EP_record.save

  end  # ends creates_new_event_participants_record

  def self.add_participants_to_event(event_obj)
    add_another = ""
    until add_another == "done"
      golfer_hash = Golfer.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Golfer.all)
      puts "\n"
      puts "Which golfers from above do you want to add to this event?"
      puts "(submit their corrospinding number)" 
      puts "\n"

      selection_number = gets.chomp.downcase
      # Verifies golfer selection is valid, else asks user to try again 
      selection_number = Golfer.verifies_valid_selection_else_retry(selection_number,golfer_hash)

      # adds new record in event_participants table for Golfer and Event combo
      golfer_obj = Golfer.find_by(name: golfer_hash[selection_number.to_i])
      selection_number = EventParticipant.creates_new_event_participants_record(event_obj.id, golfer_obj.id)
      
      puts "\nIf you are done adding Golfers to this event, type 'done'."
      puts "Otherwise, hit <enter> to add another"
        add_another = gets.chomp.downcase
    end  # ends Until loop
  end
  

end  # end EventParticipant class
