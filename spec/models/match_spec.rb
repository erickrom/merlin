require 'spec_helper'

describe Match do
  it { should respond_to(:group) }
  it { should respond_to(:round) }
  it { should respond_to(:local) }
  it { should respond_to(:visitor) }
  it { should respond_to(:visitor) }
  it { should respond_to(:local_shield) }
  it { should respond_to(:visitor_shield) }
  it { should respond_to(:schedule) }
  it { should respond_to(:local_goals) }
  it { should respond_to(:visitor_goals) }

  describe "associations" do
    it { should belong_to :league }
  end

  describe "#save_from_json" do
    let(:league) { create(:league) }
    let(:json) { load_fixture('matches_response', 'json') }

    it "creates new matches if new" do
      expect{ described_class.save_from_json(json, league.id) }.to change{ Match.count }.by(2)
    end

    it "updates the matches if already created" do
      described_class.save_from_json(json, league.id)
      expect(Match.count).to eq(2)

      described_class.save_from_json(json, league.id)
      expect(Match.count).to eq(2)
    end

    it "returns the matches" do
      matches = described_class.save_from_json(json, league.id)
      match_1 = Match.find(1)
      match_2 = Match.find(2)
      expect(matches).to eq([match_1, match_2])
    end
  end
end
