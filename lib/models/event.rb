class Event < ActiveRecord::Base

  extend ListUtilities

  belongs_to :course
  has_many :event_participants
  has_many :golfers, through: :event_participants
  has_many :holes, through: :course
  has_many :scores


  def self.create_event

    course_names_hash = Course.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Course.all)
    puts "Which course number do you want to create the event for?"
      course_selection = gets.chomp
    course_obj = Course.find_by(name: course_names_hash[course_selection.to_i])

    newevent = Event.new

    puts "What is the event's name"
    newevent.name = gets.chomp
    puts "Date of event: (YYYY-MM-DD)"
    newevent.date = gets.chomp
    newevent.course_id = course_obj.id
    newevent.save
    puts "Event Saved.  Type 'yes' if you'd like to add participants to this event"
      answer = gets.chomp.downcase
      if answer == "yes"
        EventParticipant.add_participants_to_event(newevent)
      end
  end
  
  def self.list_registered_events_for_selection_with_custom_message(custom_message="")
    puts "\n ----Registered Events----"
    event_hash = Event.print_valid_options_and_return_hash_with_tempid_and_obj_combos(Event.all)
    puts "\n"
    puts custom_message
      event_hash_selection = gets.chomp; puts "\n"
      # puts "\n"    
    event_hash_selection = Event.verifies_valid_selection_else_retry(event_hash_selection,event_hash)
    event_obj = Event.find_by(name: event_hash[event_hash_selection.to_i])
    event_obj
  end
  def self.list_events_user_is_registered_for_with_custom_message(golfer_obj,custom_message="")
    puts "\n ----Registered Events----"

    arr_golfers_events = []
    EventParticipant.where(golfer_id: golfer_obj).each { |ep_obj| arr_golfers_events << ep_obj.event }
    event_hash = Event.print_valid_options_and_return_hash_with_tempid_and_obj_combos(arr_golfers_events)
    puts "\n"
    puts custom_message
      event_hash_selection = gets.chomp; puts "\n"
      # puts "\n"    
    event_hash_selection = Event.verifies_valid_selection_else_retry(event_hash_selection,event_hash)
    event_obj = Event.find_by(name: event_hash[event_hash_selection.to_i])
    event_obj
  end

  def self.prints_list_of_events_for_golfer_returning_events_hash(golfer_obj)
        arr_golfers_event_objs = [] 
        EventParticipant.all.where(golfer_id: golfer_obj).each { |obj| arr_golfers_event_objs << obj.event}
        events_hash = Event.print_valid_options_and_return_hash_with_tempid_and_obj_combos(arr_golfers_event_objs)
        events_hash
  end  # ends prints_list_of_events_for_golfer_returning_events_hash

end  # end Event class
