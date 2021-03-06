require 'rails_helper'

describe Tournament do
  it { is_expected.to respond_to(:name) }

  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :league }
    it { is_expected.to have_many :predictions }
  end

  describe "is_user_in_tournament?" do
    let(:user) { create(:user) }
    let(:tournament) { create(:tournament, user: user) }
    let(:user_not_in_tournament) { create(:user) }

    it "returns true for a user in the tournament" do
      expect(tournament.is_user_in_tournament?(user)).to be_truthy
    end

    it "returns false for a user not in the tournament" do
      expect(tournament.is_user_in_tournament?(user_not_in_tournament)).to be_falsey
    end
  end
end
