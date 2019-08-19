class ChangeColumnNameScores < ActiveRecord::Migration[5.2]
  def change
    rename_column :scores, :score, :strokes
  end
end
