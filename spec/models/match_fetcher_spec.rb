require 'spec_helper'

describe MatchFetcher do
  describe '#get_matches' do
    let(:league) { create(:league) }
    let(:group) { 2 }
    let(:round) { 3 }

    subject { described_class.get_matches(league, group, round) }

    before do
      AppSetting.where(name: 'seconds_to_fetch_matches').first_or_create(value: 300)
      stub_matches_request(200, league: league.external_id, round: round, group: group)
    end

    context 'when there is match data in the db' do
      let!(:match_1) { create(:match, league: league, group: group, round: round) }
      let!(:match_2) { create(:match, league: league, group: group, round: round) }


      context 'when the data is stale' do
        before do
          match_1.update_attributes!(updated_at: 10.minutes.ago)
          match_2.update_attributes!(updated_at: 10.minutes.ago)
        end

        it 'makes a request to get the matches' do
          subject
          expect_matches_request(league: league.external_id, group: group, round: round)
        end
      end

      context 'when the data is recent' do
        before do
          match_1.update_attributes!(updated_at: 1.minutes.ago)
          match_2.update_attributes!(updated_at: 1.minutes.ago)
        end

        it 'doesnt make a request to get the matches' do
          ResultadosFutbol.should_not_receive(:get_matches)
          subject
        end

        it 'returns the db data' do
          expect(subject).to match_array([match_1, match_2])
        end
      end
    end

    it 'creates the matches' do
      expect { subject }.to change { Match.count }.by(2)
    end

    it 'returns an array of matches' do
      matches = subject
      match_1 = Match.find(1)
      match_2 = Match.find(2)
      expect(matches).to eq([match_1, match_2])
    end

    it 'ommits the group param if theres only one' do
      league = create(:league, total_group: 1)
      stub_matches_request(200, league: league.external_id, round: round)
      described_class.get_matches(league, 1, round)
    end
  end
end
