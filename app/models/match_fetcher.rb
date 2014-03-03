class MatchFetcher
  class << self
    def get_matches(league, group, round)
      group = league.total_group == 1 ? nil : group
      json_response = ResultadosFutbol.get_matches(league.external_id, group, round)
      Match.save_from_json(json_response, league.id)
    end
  end
end
