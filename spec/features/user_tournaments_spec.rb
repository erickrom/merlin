require 'spec_helper'

describe "User Tournaments" do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  before do
    visit signin_path
    sign_in(user)
  end

  describe "in the user's home page" do
    context "when the user has no tournaments yet" do
      it "shows no tournaments yet text and a button to create a new one" do
        expect(page).to have_content /You aren't playing any tournaments yet/
      end

      it "takes you to the new tournament page" do
        click_link 'New Tournament'
        expect(page).to have_content('Create a New Tournament!')
      end
    end

    context "when the user has created some tournaments" do
      let!(:tournament_1) { create(:tournament, user: user, name: 'My friends tournament') }
      let!(:tournament_2) { create(:tournament, user: user, name: 'My co-workers tournament') }

      it "shows the tournaments summary" do
        visit user_path(user)
        expect(page).to have_content(tournament_1.name)
        expect(page).to have_content(tournament_2.name)
      end
    end
  end

  describe "creating a new tournament" do
    before do
      visit user_path(user)
    end

    it "lets you create a tournament from the user's main page" do
      expect(page).to have_link('New Tournament', href: new_tournament_path)
    end
  end
end
