require 'spec_helper'

describe ResultadosFutbol do
  describe "#get_leagues" do
    before do
      stub_leagues_request
    end

    it "makes a request to resultados futbol for leagues" do
      ResultadosFutbol.get_leagues
      expect_leagues_request
    end
  end

  describe "#get_matches" do
    let(:league) { create(:league) }
    let(:round) { 3 }
    let(:group) { 2 }

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
