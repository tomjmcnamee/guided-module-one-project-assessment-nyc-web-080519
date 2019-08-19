class CreateHoles < ActiveRecord::Migration[5.2]
  def change
    create_table :holes do |t|
      t.integer :hole_number
      t.integer :course_id
      t.integer :distance
      t.integer :hole_handicap
    end  # ends create_table loop
  end  # ends change method
end  # ends CreateHoles class
