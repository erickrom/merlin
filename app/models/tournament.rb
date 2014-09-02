class Tournament < ActiveRecord::Base
  belongs_to :user, inverse_of: :tournaments

  belongs_to :league

  has_many :predictions

  def is_user_in_tournament?(user)
    return true if self.user == user
    false
  end
end
