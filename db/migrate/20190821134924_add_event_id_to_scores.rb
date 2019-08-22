class AddEventIdToScores < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :event_id, :integer
  end
end
