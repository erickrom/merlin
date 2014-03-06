require 'spec_helper'

describe TournamentsController do
  include SessionsHelper

  let(:user) { create(:user) }

  shared_examples_for "an action that requires a signed-in user" do
    before do
      sign_out
    end

    it "redirects to the sign in page" do
      expect(make_request).to redirect_to(signin_url)
    end
  end

  describe "GET new" do
    def make_request
      get :new
    end

    let(:league_1) { create(:league, name: 'Champions League') }
    let(:league_2) { create(:league, name: 'Copa del Rey') }

    before do
      sign_in_user user
    end

    it "shows the New Tournament page" do
      make_request.should render_template('tournaments/new')
    end

    it "calls the league fetcher" do
      LeagueFetcher.should_receive(:get_leagues).and_return([league_1, league_2])
      make_request
    end

    it "assigns the available leagues" do
      make_request
      expect(assigns(:leagues)).to eq([league_1, league_2])
    end

    it_behaves_like "an action that requires a signed-in user"
  end

  describe "POST create" do
    let(:params) { {"tournament" => {"name" => "My First Tournament", "league" => "1"}} }

    before do
      sign_in_user user
    end

    def make_request
      post :create, params
    end

    it "creates a new tournament" do
      expect { make_request }.to change { Tournament.count }.by(1)
    end

    it "shows the success flash message" do
      make_request
      expect(flash[:success]).to eq("Created New Tournament My First Tournament")
    end

    it_behaves_like "an action that requires a signed-in user"
  end

  describe "GET show" do
    let(:tournament) { create(:tournament, user: user) }
    let!(:match_1) { create(:match, league: tournament.league) }
    let(:group) { 1 }
    let(:round) { tournament.league.current_round }

    before do
      MatchFetcher.stub(:get_matches).with(tournament.league, group, round).and_return([match_1])
    end

    def make_request
      get :show, id: tournament.id
    end

    context "for a user in the tournament" do
      before do
        sign_in_user user
      end

      it "assigns the tournament and rounds data" do
        make_request
        expect(assigns(:tournament)).to eq(tournament)
        expect(assigns(:rounds)).to eq(tournament.league.total_rounds)
        expect(assigns(:current_round)).to eq(tournament.league.current_round)
      end

      context "when the group param is not passed" do
        it "assigns the group" do
          make_request
          expect(assigns(:group)).to eq(1)
        end
      end

      context "when the group param is passed" do
        context "when the group is valid" do
          it "assigns the group" do
            MatchFetcher.stub(:get_matches).with(tournament.league, 2, round).and_return([match_1])
            get :show, id: tournament.id, group: 2
            expect(assigns(:group)).to eq(2)
          end
        end

        context "when the group is not valid" do
          it "assigns the group to 1" do
            get :show, id: tournament.id, group: 100
            expect(assigns(:group)).to eq(1)
          end
        end
      end

      describe "matches" do
        it "calls the MatchFetcher" do
          MatchFetcher.should_receive(:get_matches).with(tournament.league, group, round).and_return([match_1])
          make_request
        end

        it "assigns the matches" do
          make_request
          expect(assigns(:matches)).to eq([match_1])
        end
      end
    end

    context "for a user not in the tournament" do
      let(:user_not_in_tournament) { create(:user) }

      it "doesn't allow access" do
        sign_in_user user_not_in_tournament
        expect(make_request).to redirect_to(user_path(user_not_in_tournament))
      end
    end

    it_behaves_like "an action that requires a signed-in user"
  end

end
