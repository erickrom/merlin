require 'spec_helper'

describe TournamentsController do
  include SessionsHelper

  describe "GET new" do
    def make_request
      get :new
    end

    describe "for a signed in user" do
      let(:league_1) { create(:league, name: 'Champions League')}
      let(:league_2) { create(:league, name: 'Copa del Rey')}

      let(:user) { create(:user) }

      before do
        sign_in_user user
      end

      it "shows the New Tournament page" do
        make_request.should render_template('tournaments/new')
      end

      it "assigns the available leagues" do
        make_request
        expect(assigns(:leagues)).to eq([league_1, league_2])
      end
    end

    describe "for a not-signed in user" do
      it "redirects to the sign in page" do
        expect(make_request).to redirect_to(signin_url)
      end
    end
  end

  describe "POST create" do
    let(:user) { create(:user) }
    let(:params) { {"tournament"=>{"name"=>"My First Tournament", "league"=>"1"}} }

    before do
      sign_in_user user
    end

    def make_request
      post :create, params
    end

    it "creates a new tournament" do
      expect{ make_request }.to change { Tournament.count }.by(1)
    end

    it "shows the success flash message" do
      make_request
      expect(flash[:success]).to eq("Created New Tournament My First Tournament")
    end
  end
end
