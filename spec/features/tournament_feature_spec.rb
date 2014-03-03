require 'spec_helper'

describe "Tournament Page" do
  include FeatureSpecHelpers

  let(:user) { create(:user) }
  let(:league) { create(:league) }
  let(:tournament) { create(:tournament, league: league, user: user) }
  let(:match_1) { create(:match, league: league, round: league.current_round,
                         local: 'Milan', visitor: 'Ajax', local_goals: 0, visitor_goals: 0) }

  before do
    MatchFetcher.stub(:get_matches).and_return([match_1])
  end

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
        expect(page).to have_content(tournament.league.name)
      end

      it "shows the matches for the current round" do
        visit tournament_path(tournament)
        expect(page).to have_select('group', selected: 'Group 1')

        expect(page).to have_content(match_1.local)
        expect(page).to have_content(match_1.visitor)
        expect(page).to have_content(match_1.local_goals)
        expect(page).to have_content(match_1.visitor_goals)
      end

      describe "the tournament nav links" do
        shared_examples_for "visible round links" do |begin_round, last_round|
          it "shows the links" do
            for round in begin_round..last_round
              expect(page).to have_css('li a', text: "Round #{round}")
              expect(page).to have_link("Round #{round}", href: "#{tournament_path(tournament)}?round=#{round}")
            end
          end
        end

        shared_examples_for "hidden round links" do |begin_round, last_round|
          it "doesn't shows the links" do
            for round in begin_round..last_round
              expect(page).not_to have_css('li a', text: "Round #{round}")
              expect(page).not_to have_link("Round #{round}", href: "#{tournament_path(tournament)}?round=#{round}")
            end
          end
        end

        it "has the pagination area" do
          visit tournament_path(tournament)
          expect(page).to have_css('ul.pagination')
        end
        context "when we have 8 or less total rounds" do
          before do
            league.update_attributes!(total_rounds: 8)
            visit tournament_path(tournament)
          end

          it_should_behave_like "visible round links", 1, 8
        end

        context "when we have more than 8 total rounds" do
          before do
            league.update_attributes!(total_rounds: 10)
            visit tournament_path(tournament)
          end

          context "when the current round is 4 of less" do
            it_should_behave_like "visible round links", 1, 4
            it_should_behave_like "hidden round links", 5, 6
            it_should_behave_like "visible round links", 7, 10
          end

          context "when the current round is more than 4 but less than total-3" do
            before do
              league.update_attributes!(current_round: 5)
              visit tournament_path(tournament)
            end
            it_should_behave_like "visible round links", 1, 1
            it_should_behave_like "hidden round links", 2, 3
            it_should_behave_like "visible round links", 4, 6
            it_should_behave_like "hidden round links", 7, 9
            it_should_behave_like "visible round links", 10, 10
          end

          context "when the current round is between total-3 and total" do
            before do
              league.update_attributes!(current_round: 8)
              visit tournament_path(tournament)
            end
            it_should_behave_like "visible round links", 1, 4
            it_should_behave_like "hidden round links", 5, 6
            it_should_behave_like "visible round links", 7, 10
          end
        end
      end
    end
  end
end
