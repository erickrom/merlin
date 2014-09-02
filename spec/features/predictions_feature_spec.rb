require 'spec_helper'

describe "Adding predictions to a tournament", js: true do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  let(:league) { create(:league) }
  let(:tournament) { create(:tournament, user: user, league: league) }
  let(:match_1) { create(:match, league: league) }
  let(:match_2) { create(:match, league: league) }

  before do
    MatchFetcher.stub(:get_matches).and_return([match_1, match_2])
    visit signin_path
    sign_in_user(user)
  end

  def expect_page_to_not_show_prediction_form_for_match(match)
    page.should_not have_css("#edit_prediction_match_#{match.id}")
    page.should_not have_css("#prediction_match_#{match.id}_local_goals")
    page.should_not have_css("#prediction_match_#{match.id}_visitor_goals")
  end

  def expect_page_to_show_prediction_form_for_match(match)
    page.should have_css("#edit_prediction_match_#{match.id}")
    page.should have_css("#prediction_match_#{match.id}_local_goals")
    page.should have_css("#prediction_match_#{match.id}_visitor_goals")
  end

  def expect_page_to_show_prediction_for(prediction_id)
    #page.should have_text('My Prediction')
  end

  context "when the tournament has no prediction for the current user" do
    it "allows the user to enter a prediction" do
      visit tournament_path(tournament)

      expect(page).to have_content("Add Prediction")
      expect_page_to_not_show_prediction_form_for_match(match_1)
      expect_page_to_not_show_prediction_form_for_match(match_2)

      page.within "#match_#{match_1.id}" do
        click_link 'Add Prediction'
        #expect(page).to have_content("Save Prediction")
        expect_page_to_show_prediction_form_for_match(match_1)

        fill_in 'prediction[local_goals]', with: '1'
        fill_in 'prediction[visitor_goals]', with: '2'

        #expect { click_on "Save Prediction" }.to change { Prediction.count }.by(1)
        click_on 'Save Prediction'

        expect_page_to_show_prediction_for(match_1)
      end
    end
  end
end
