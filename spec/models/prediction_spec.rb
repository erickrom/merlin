require 'rails_helper'

describe Prediction do
  describe 'associations' do
    it { is_expected.to belong_to :tournament }
    it { is_expected.to belong_to :match }
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :tournament }
    it { is_expected.to validate_presence_of :match }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :local_goals }
    it { is_expected.to validate_presence_of :visitor_goals }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:match_id) }
  end
end
