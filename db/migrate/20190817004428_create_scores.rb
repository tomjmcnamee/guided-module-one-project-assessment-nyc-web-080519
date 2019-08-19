class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :golfer_id
      t.integer :hole_id
      t.integer :score
    end  # ends create_table loop
  end  # ends change loop
end  # ends CreateScores class 
