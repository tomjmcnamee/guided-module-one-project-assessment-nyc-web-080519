class AddParToHoles < ActiveRecord::Migration[5.2]
  def change
    add_column :holes, :par, :integer
  end
end
