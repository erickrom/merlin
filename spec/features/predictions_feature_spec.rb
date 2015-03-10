require 'spec_helper'

describe 'Adding predictions to a tournament', js: true do
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

  def expect_page_to_show_prediction_for(prediction)
    page.should have_css("#my_prediction_match_#{prediction.match.id}", count: 1)
    page.should have_css("#my_prediction_match_#{prediction.match.id} td", text: prediction.local_goals)
    page.should have_css("#my_prediction_match_#{prediction.match.id} td", text: prediction.visitor_goals)
  end

  context 'when the tournament has no prediction for the current user' do
    it 'allows the user to enter a prediction' do
      visit tournament_path(tournament.id)

      expect(page).to have_content('Add Prediction')
      expect_page_to_not_show_prediction_form_for_match(match_1)
      expect_page_to_not_show_prediction_form_for_match(match_2)

      page.within "#match_#{match_1.id}" do
        click_link 'Add Prediction'
        #expect(page).to have_content("Save Prediction")
        expect_page_to_show_prediction_form_for_match(match_1)

        fill_in 'prediction[local_goals]', with: '1'
        fill_in 'prediction[visitor_goals]', with: '2'

        click_on 'Save Prediction'
      end

      expect(page).to have_content 'Prediction saved successfully'

      page.should have_text(user.first_name)

      last_prediction = Prediction.last
      expect_page_to_show_prediction_for(last_prediction)
    end
  end

  context 'when the tournament has a prediction for the user' do
    let!(:prediction) { create(:prediction, user: user, tournament: tournament, match: match_1) }

    it 'shows the predictions' do
      visit tournament_path(tournament)

      expect_page_to_show_prediction_for(prediction)
    end

    it 'allows the user to edit their prediction' do
      visit tournament_path(tournament)

      page.within "#match_#{match_1.id}" do
        expect(page).to have_text('Edit Prediction')

        click_on 'Edit Prediction'
        #expect(page).to have_text('Save Prediction')

        fill_in 'prediction[local_goals]', with: '4'
        fill_in 'prediction[visitor_goals]', with: '3'

        click_on 'Save Prediction'
      end

      expect(page).to have_content 'Prediction saved successfully'

      page.should have_content(user.first_name)

      expect_page_to_show_prediction_for(prediction.reload)

      expect(prediction.local_goals).to eq 4
      expect(prediction.visitor_goals).to eq 3
      expect_page_to_show_prediction_for(prediction)
    end
  end
end
