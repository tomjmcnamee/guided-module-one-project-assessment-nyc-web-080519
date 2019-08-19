class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :address
      t.string :phone_number
    end  # end create_table loop  
  end  # ends change method
end  # ends CreateCourse class
