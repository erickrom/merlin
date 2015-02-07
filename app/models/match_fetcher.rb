class MatchFetcher
  class << self
    def get_matches(league, group, round)
      group = league.total_group == 1 ? nil : group

      db_matches = get_db_matches_if_recent(league, group, round)

      return db_matches if db_matches.present?

      json_response = ResultadosFutbol.get_matches(league.external_id, group, round)
      Match.save_from_json(json_response, league.id)
    end

    private

    def get_db_matches_if_recent(league, group, round)
      db_matches = Match.where(league: league, group: group, round: round).order('updated_at DESC')

      return nil if db_matches.empty?

      most_recent = db_matches.first

      seconds_to_wait_for_fetch = AppSetting.where(name: 'seconds_to_fetch_matches').first.value.to_i

      if most_recent.updated_at > Time.now - seconds_to_wait_for_fetch.seconds
        return db_matches
      else
        return nil
      end
    end
  end
end
