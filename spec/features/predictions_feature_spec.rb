require 'rails_helper'

describe 'Adding predictions to a tournament', js: true do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  let(:league) { create(:league) }
  let(:tournament) { create(:tournament, user: user, league: league) }
  let(:match_1) { create(:match, league: league) }
  let(:match_2) { create(:match, league: league) }

  before do
    allow(MatchFetcher).to receive(:get_matches).and_return([match_1, match_2])
    visit signin_path
    sign_in_user(user)
  end

  def expect_page_to_not_show_prediction_form_for_match(match)
    within "#teams_match_#{match.id}" do
      expect(page).to_not have_field 'local_goals', type: 'number'
      expect(page).to_not have_field 'visitor_goals', type: 'number'
    end
  end

  def expect_page_to_show_prediction_form_for_match(match)
    within "#teams_match_#{match.id}" do
      expect(page).to have_field 'local_goals', type: 'number'
      expect(page).to have_field 'visitor_goals', type: 'number'
    end
  end

  def expect_page_to_show_prediction_for(prediction)
    expect(page).to have_css("##{prediction.user.first_name}_#{prediction.match.id}_local_goals", text: prediction.local_goals)
    expect(page).to have_css("##{prediction.user.first_name}_#{prediction.match.id}_visitor_goals", text: prediction.visitor_goals)
  end

  context 'when the tournament has no prediction for the current user' do
    it 'lets the user enter a prediction' do
      visit tournament_path(tournament.id)

      expect(page).to have_content('Add prediction')

      expect_page_to_show_prediction_form_for_match(match_1)
      within "#teams_match_#{match_1.id}" do
        fill_in 'local_goals', with: '1'
        fill_in 'visitor_goals', with: '2'

        click_on 'Add prediction'
      end

      expect(page).to have_content 'Prediction saved successfully'

      expect(page).to have_text(user.first_name)

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

      expect_page_to_not_show_prediction_form_for_match(match_1)

      page.within "#match_#{match_1.id}" do
        expect(page).to have_text('Edit Prediction')

        click_on 'Edit Prediction'

        fill_in 'prediction[local_goals]', with: '4'
        fill_in 'prediction[visitor_goals]', with: '3'

        click_on 'Save Prediction'
      end

      expect(page).to have_content 'Prediction saved successfully'

      expect(page).to have_content(user.first_name)

      expect_page_to_show_prediction_for(prediction.reload)

      expect(prediction.local_goals).to eq 4
      expect(prediction.visitor_goals).to eq 3
      expect_page_to_show_prediction_for(prediction)
    end
  end
end
