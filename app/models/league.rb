class League < ActiveRecord::Base

  class << self
    def save_leagues_from_json(json_payload)
      json_object = JSON.parse(json_payload)
      leagues = json_object["league"]

      League.transaction do
        leagues.each do |league|
          league = create_from_json(league)
          league.save!
        end
      end
    end

    private

    def create_from_json(json_league)
      League.new(
        name: json_league["name"],
        external_id: json_league["id"].to_i,
        year: json_league["year"].to_i,
        group_code: json_league["group_code"].to_i,
        playoff: json_league["playoff"] == "1",
        current_round: json_league["current_round"].to_i,
        total_group: json_league["total_group"].to_i,
        total_rounds: json_league["total_rounds"].to_i,
        flag_url_path: json_league["flag"]
      )
    end

  end
end
