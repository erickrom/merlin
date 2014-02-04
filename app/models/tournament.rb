class Tournament < ActiveRecord::Base
  belongs_to :user, inverse_of: :tournaments

  belongs_to :league
end
