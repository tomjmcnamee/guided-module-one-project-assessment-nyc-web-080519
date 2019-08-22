class AddScheduleteetimeToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :schedule_tee_time, :string
  end
end
