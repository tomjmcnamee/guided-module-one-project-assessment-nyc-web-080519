class AddFrontbackallToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :front_back_all, :string
  end
end
