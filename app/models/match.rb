class Match < ActiveRecord::Base
  belongs_to :league

  class << self
    def save_from_json(json, league_id)
      json_object = JSON.parse(json)
      matches = json_object["match"]
      matches_result = []
      Match.transaction do
        matches.each do |match_json|
          match = create_or_initialize_from_json(match_json, league_id)
          match.save!
          matches_result << match
        end
      end
      matches_result
    end

    private

    def create_or_initialize_from_json(json, league_id)
      match = Match.where(league_id: league_id, group: json["group"], round: json["round"],
                          local: json["local"], visitor: json["visitor"]).first_or_initialize
      match.update_attributes(local_shield: json["local_shield"], visitor_shield: json["visitor_shield"],
                                schedule: DateTime.parse(json["schedule"]),
                                local_goals: json["local_goals"],
                                visitor_goals: json["visitor_goals"])
      match
    end
  end
end
