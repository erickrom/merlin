class LeagueFetcher
  class << self
    def get_leagues
      last_fetch_time = AppSetting.where(name: 'last_league_fetch').first.value

      if Time.parse(last_fetch_time).utc > 1.hour.ago
        get_leagues_from_db
      else
        fetch_leagues
      end
    end

    private

    def get_leagues_from_db
      year = Time.now.utc.year
      League.where('year >= ?', year)
    end

    def fetch_leagues
      response = ResultadosFutbol.get_leagues

      return get_leagues_from_db if response.status != 200

      AppSetting.first_or_create!(name: 'last_league_fetch').update_attributes!(value: Time.now.utc.to_s)

      League.save_leagues_from_json(response.body)
      get_leagues_from_db
    end
  end
end
