class Hole < ActiveRecord::Base

  belongs_to :course
  has_many :scores
  has_many :golfers, through: :scores

end  # end Hole class
