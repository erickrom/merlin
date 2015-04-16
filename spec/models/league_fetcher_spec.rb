require 'rails_helper'

describe LeagueFetcher do
  let(:current_time) { Time.now.utc }
  let!(:last_year_league) { create(:league, year: Time.now.year - 1) }
  let!(:this_year_league) { create(:league, year: Time.now.year) }
  let!(:two_years_ago_league) { create(:league, year: Time.now.year - 2) }
  let!(:next_year_league) { create(:league, year: Time.now.year + 1) }

  describe "#get_leagues" do
    context "when we have fetched league data in the last hour" do
      before do
        last_fetch = current_time - 5.minutes
        AppSetting.first_or_create(name: 'last_league_fetch').update_attributes!(value: last_fetch.to_s)
      end

      it "returns the leagues for the current year from the db" do
        Timecop.freeze(current_time) do
          expect(LeagueFetcher.get_leagues).to eq([this_year_league, next_year_league])
        end
      end

      it "doesn't make a call to the ResultadosFutbol api" do
        expect(ResultadosFutbol).to_not receive(:get_leagues)
        LeagueFetcher.get_leagues
      end
    end

    context "when it's been over an hour since we last fetched league data" do
      before do
        last_fetch = current_time - 61.minutes
        AppSetting.first_or_create!(name: 'last_league_fetch').update_attributes!(value: last_fetch.to_s)
        stub_leagues_request
      end

      it "calls ResultadosFutbol webservice to fetch latest league data" do
        Timecop.freeze(current_time) do
          response = double('league response object')
          allow(response).to receive(:status).and_return(200)
          allow(response).to receive(:body).and_return(load_fixture('leagues_response', 'json'))
          expect(ResultadosFutbol).to receive(:get_leagues).and_return(response)
          LeagueFetcher.get_leagues
        end
      end

      it "updates the last_league_fetch value" do
        Timecop.freeze(current_time) do
          LeagueFetcher.get_leagues
          expect(AppSetting.where(name: 'last_league_fetch').first.value).to eq(current_time.to_s)
        end
      end

      it "updates the leagues in the db" do
        Timecop.freeze(current_time) do
          expect { LeagueFetcher.get_leagues }.to change { League.count }
        end
      end

      it "returns the saved leagues" do
        Timecop.freeze(current_time) do
          expect(LeagueFetcher.get_leagues).to be_a(ActiveRecord::Relation::ActiveRecord_Relation_League)
        end
      end

      context "when the api server is unhappy" do
        before do
          stub_leagues_request(404)
        end

        it "returns the leagues from the db" do
          expect(LeagueFetcher.get_leagues).to eq([this_year_league, next_year_league])
        end
      end
    end
  end
end
