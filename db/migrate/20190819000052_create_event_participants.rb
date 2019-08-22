class CreateEventParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :event_participants do |t|
      t.integer :event_id
      t.integer :golfer_id
    end  # ends create table loop
  end
end
