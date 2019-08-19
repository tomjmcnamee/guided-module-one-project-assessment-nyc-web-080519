class AddUrlToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :url, :string
  end
end
