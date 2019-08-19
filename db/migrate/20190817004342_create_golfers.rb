class CreateGolfers < ActiveRecord::Migration[5.2]
  def change
    create_table :golfers do |t|
      t.string :name
      t.integer :age
      t.integer :player_handicap
    end  # ends create_table loop
  end  # ends change method
end
