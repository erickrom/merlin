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

  describe 'associations' do
    it { should belong_to :league }
    it { should have_many(:predictions).dependent(:destroy) }
  end

  describe '#save_from_json' do
    let(:league) { create(:league) }
    let(:json) { load_fixture('matches_response', 'json') }

    it 'creates new matches if new' do
      expect{ described_class.save_from_json(json, league.id) }.to change{ Match.count }.by(2)
    end

    it 'updates the matches if already created' do
      described_class.save_from_json(json, league.id)
      expect(Match.count).to eq(2)

      described_class.save_from_json(json, league.id)
      expect(Match.count).to eq(2)
    end

    it 'returns the matches' do
      matches = described_class.save_from_json(json, league.id)
      match_1 = Match.find(1)
      match_2 = Match.find(2)
      expect(matches).to eq([match_1, match_2])
    end
  end

  describe '#predictions_for_tournament' do
    let(:league) { create(:league) }
    let(:match) { create(:match, league: league) }
    let(:tournament_1) { create(:tournament, league: league) }

    let(:prediction_1) { create(:prediction, match: match, tournament: tournament_1) }
    let(:prediction_2) { create(:prediction, match: match) }

    it 'returns all the predictions on the specified tournament' do
      expect(match.predictions_for_tournament(tournament_1)).to eq([prediction_1])
    end
  end

  describe '#get_prediction_for' do
    let(:user) { create(:user) }
    let(:league) { create(:league) }
    let(:tournament) { create(:tournament, league: league) }
    let(:match) { create(:match, league: league) }

    it 'returns the prediction for the match, user, and tournament' do
      prediction = create(:prediction, user: user, match: match, tournament: tournament )
      expect(match.get_prediction_for(user, tournament)).to eq(prediction)
    end
  end
end
