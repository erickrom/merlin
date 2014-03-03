require 'spec_helper'

describe MatchFetcher do
  describe "#get_matches" do
    let(:league) { create(:league) }
    let(:group) { 2 }
    let(:round) { 3 }

    subject { described_class.get_matches(league, group, round) }

    before do
      stub_matches_request(200, league: league.external_id, round: round, group: group)
    end

    it "makes a request to get the matches" do
      subject
      expect_matches_request(league: league.external_id, group: group, round: round)
    end

    it "creates the matches" do
      expect { subject }.to change { Match.count }.by(2)
    end

    it "returns an array of matches" do
      matches = subject
      match_1 = Match.find(1)
      match_2 = Match.find(2)
      expect(matches).to eq([match_1, match_2])
    end
  end
end
