class Prediction < ActiveRecord::Base
  belongs_to :tournament, inverse_of: :predictions
  belongs_to :match, inverse_of: :predictions
  belongs_to :user, inverse_of: :predictions
end
