require 'rails_helper'

describe PredictionsController do
  include SessionsHelper

  let(:user) { create(:user) }
  let(:match) { create(:match) }
  let(:tournament) { create(:tournament, user: user) }

  before do
    sign_in_user user
  end

  describe 'GET new' do
    def make_request
      get :new, match_id: match.id, tournament_id: tournament.id
    end

    it_behaves_like 'an action that requires a signed-in user'

    it 'assigns and initializes the prediction' do
      make_request
      expect(assigns(:prediction).match).to eq(match)
      expect(assigns(:prediction).tournament).to eq(tournament)
    end
  end

  describe 'POST create' do
    let(:params) {
      {
        "prediction" => {
          "local_goals" => "1",
          "visitor_goals" => "2",
          "match_id" => "#{match.id}",
          "tournament_id" => "#{tournament.id}",
        }
      }
    }

    before do
      request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
    end

    def make_request
      post :create, params
    end

    it_behaves_like 'an action that requires a signed-in user'

    it 'creates a new prediction' do
      expect { make_request }.to change { Prediction.count }.by(1)

      last_prediction = Prediction.last
      expect(last_prediction.local_goals).to eq(1)
      expect(last_prediction.visitor_goals).to eq(2)
      expect(last_prediction.match).to eq(match)
      expect(last_prediction.tournament).to eq(tournament)
    end
  end

  describe 'PATCH update' do
    let(:tournament) { create(:tournament) }
    let(:match) { create(:match, league: tournament.league) }
    let(:prediction) { create(:prediction, user: user, match: match, tournament: tournament,
                              local_goals: 1, visitor_goals: 3) }
    let(:params) {
      {
        "prediction"=>
          {"tournament_id"=>"#{tournament.id}", "match_id"=>"#{match.id}", "local_goals"=>"2", "visitor_goals"=>"1"},
        "id"=>"#{prediction.id}"}
    }

    before do
      request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
    end

    def make_request
      patch :update, params
    end

    it_behaves_like 'an action that requires a signed-in user'

    it 'updates a prediction' do
      make_request

      expect(prediction.reload.local_goals).to eq(2)
      expect(prediction.visitor_goals).to eq(1)
    end
  end
end
