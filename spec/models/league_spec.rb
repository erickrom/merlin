require 'spec_helper'

describe League do
  it { should respond_to(:name) }
  it { should respond_to(:external_id) }
  it { should respond_to(:year) }
  it { should respond_to(:group_code) }
  it { should respond_to(:playoff) }
  it { should respond_to(:current_round) }
  it { should respond_to(:total_group) }
  it { should respond_to(:total_rounds) }
  it { should respond_to(:flag_url_path) }

  context ".external_id" do
    it "should be unique" do
      league = create(:league)
      duplicate_league = League.new(name: 'Another League', external_id: league.external_id)
      duplicate_league.should_not be_valid
    end
  end

  describe ".save_from_json_and_return_all" do
    let(:json) { load_fixture('leagues_response_top', 'json') }

    subject { League.save_leagues_from_json(json) }

    it "saves the leagues from json payload" do
      expect{ subject }.to change { League.count }.by(19)
    end

    it "saves the leagues with the right data" do
      subject
      league = League.first
      expect(league.name).to eq("Champions League")
      expect(league.external_id).to eq(107)
      expect(league.year).to eq(2015)
      expect(league.group_code).to eq(1)
      expect(league.playoff).to be_falsey
      expect(league.current_round).to eq(6)
      expect(league.total_group).to eq(8)
      expect(league.total_rounds).to eq(6)
      expect(league.flag_url_path).to eq("http:\/\/thumb.resfu.com\/media\/img\/flags\/44x27\/ue.png")
    end

    context "when called again" do
      it "updates the attributes we care about" do
        subject
        league = League.first
        expect(league.name).to eq("Champions League")
        expect(league.external_id).to eq(107)
        expect(league.year).to eq(2015)
        expect(league.group_code).to eq(1)
        expect(league.playoff).to be_falsey
        expect(league.current_round).to eq(6)
        expect(league.total_group).to eq(8)
        expect(league.total_rounds).to eq(6)
        expect(league.flag_url_path).to eq("http:\/\/thumb.resfu.com\/media\/img\/flags\/44x27\/ue.png")

        league.update_attributes!(name: 'La Champions League')

        League.save_leagues_from_json(json)

        expect(league.reload.name).to eq('La Champions League')
        expect(league.external_id).to eq(107)
        expect(league.year).to eq(2015)
        expect(league.group_code).to eq(1)
        expect(league.playoff).to be_falsey
        expect(league.current_round).to eq(6)
        expect(league.total_group).to eq(8)
        expect(league.total_rounds).to eq(6)
        expect(league.flag_url_path).to eq("http:\/\/thumb.resfu.com\/media\/img\/flags\/44x27\/ue.png")
      end
    end
  end
end
