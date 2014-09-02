require 'spec_helper'

describe Prediction do
  describe 'associations' do
    it { should belong_to :tournament }
    it { should belong_to :match }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :tournament }
    it { should validate_presence_of :match }
    it { should validate_presence_of :user }
    it { should validate_presence_of :local_goals }
    it { should validate_presence_of :visitor_goals }
  end
end
