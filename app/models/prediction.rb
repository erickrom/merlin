class Prediction < ActiveRecord::Base
  belongs_to :tournament, inverse_of: :predictions
  belongs_to :match, inverse_of: :predictions
  belongs_to :user

  validates_presence_of :user, :match, :tournament, :local_goals, :visitor_goals
end
