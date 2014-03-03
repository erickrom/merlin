require 'spec_helper'

describe ResultadosFutbol do
  describe "#get_current_leagues" do
    let(:current_time) { Time.now.utc }
    let!(:last_year_league) { create(:league, year: 2013) }
    let!(:this_year_league) { create(:league, year: 2014) }
    let!(:two_years_ago_league) { create(:league, year: 2012) }
    let!(:next_year_league) { create(:league, year: 2015) }

    context "when we have never fetched league data before" do
      it "makes a request to the api server to get the leagues data" do
        AppSetting.first_or_create(name: 'last_league_fetch').update_attributes!(value: nil)
        stub_leagues_request

        Timecop.freeze(current_time) do
          ResultadosFutbol.get_current_leagues
          expect_leagues_request
        end
      end
    end

    context "when we have fetched league data in the last hour" do
      before do
        last_fetch = current_time - 5.minutes
        AppSetting.first_or_create(name: 'last_league_fetch').update_attributes!(value: last_fetch.to_s)
      end

      it "returns the leagues for the current year from the db" do
        Timecop.freeze(current_time) do
          expect(ResultadosFutbol.get_current_leagues).to eq([this_year_league, next_year_league])
        end
      end
    end

    context "when it's been over an hour since we last fetched league data" do
      before do
        last_fetch = current_time - 61.minutes
        AppSetting.first_or_create!(name: 'last_league_fetch').update_attributes!(value: last_fetch.to_s)
        stub_leagues_request
      end

      it "makes a request to the api server to get the leagues data" do
        Timecop.freeze(current_time) do
          ResultadosFutbol.get_current_leagues
          expect_leagues_request
        end
      end

      it "updates the last_league_fetch value" do
        Timecop.freeze(current_time) do
          ResultadosFutbol.get_current_leagues
          expect(AppSetting.where(name: 'last_league_fetch').first.value).to eq(current_time.to_s)
        end
      end

      it "updates the leagues in the db" do
        Timecop.freeze(current_time) do
          expect { ResultadosFutbol.get_current_leagues }.to change { League.count }
        end
      end

      it "returns the saved leagues" do
        Timecop.freeze(current_time) do
          expect(ResultadosFutbol.get_current_leagues).to be_a(ActiveRecord::Relation::ActiveRecord_Relation_League)
        end
      end

      context "when the api server is unhappy" do
        before do
          stub_leagues_request(404)
        end

        it "returns the leagues from the db" do
          expect(ResultadosFutbol.get_current_leagues).to eq([this_year_league, next_year_league])
        end
      end
    end
  end

  describe "#get_matches" do
    let(:league) { create(:league) }
    let(:round) { 2 }
    let(:group) { 1 }

    before do
      stub_matches_request(200, league: league.external_id, round: round, group: group)
    end

    subject { described_class.get_matches(league.external_id, group, round) }

    it "makes a request to resultados futbol for matches" do
      subject
      expect_matches_request(league: league.external_id, round: round, group: group)
    end
  end
end
