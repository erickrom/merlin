require 'spec_helper'

describe "Tournament Page" do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  let(:league) { create(:league) }
  let(:tournament) { create(:tournament, league: league, user: user) }

  context "for a user not in the tournament" do
    let!(:user_not_in_tournament) { create(:user) }

    before do
      visit signin_path
      sign_in_user(user_not_in_tournament)
    end

    it "doesn't let the user see the tournament page" do
      visit tournament_path(tournament)
      expect(page).not_to have_content(tournament.name)
    end
  end

  context "for a user in the tournament" do
    before do
      visit signin_path
      sign_in_user(user)
    end

    describe "landing in the tournament's page" do
      it "shows the tournament's data" do
        visit tournament_path(tournament)
        expect(page).to have_content(tournament.name)
      end
    end
  end
end
