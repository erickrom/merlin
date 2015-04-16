require 'rails_helper'

describe "User Tournaments" do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  let!(:league_1) { create(:league, name: 'Champions League')}
  let!(:league_2) { create(:league, name: 'Copa del Rey')}

  before do
    visit signin_path
    sign_in_user(user)
  end

  describe "in the user's home page" do

    it "lets you create a tournament from the user's main page" do
      expect(page).to have_link('New Tournament', href: new_tournament_path)
    end

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
        expect(page).to have_link(tournament_1.name, href: tournament_path(tournament_1))
        expect(page).to have_link(tournament_2.name, href: tournament_path(tournament_2))
      end
    end
  end

  describe "creating a new tournament" do
    before do
      allow(MatchFetcher).to receive(:get_matches).and_return([create(:match)])
      visit user_path(user)
      click_link 'New Tournament'
    end

    it "shows the available leagues" do
      expect(page).to have_content(league_1.name)
      expect(page).to have_content(league_2.name)
    end

    it "let's you create a new tournament" do
      fill_in "Name", :with => 'My First Tournament'
      within("#leagues") do
        choose("tournament_league_#{league_1.id}")
      end

      click_button 'Create New Tournament!'

      expect(page).to have_content("Created New Tournament My First Tournament")
    end
  end
end
