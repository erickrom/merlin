class MatchFetcher
  class << self
    def get_matches(league, group, round)
      json_response = ResultadosFutbol.get_matches(league.external_id, group, round)
      Match.save_from_json(json_response, league.id)
    end
  end
end
