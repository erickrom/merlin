class ResultadosFutbol
  class << self
    def get_current_leagues
      last_fetch_time = AppSetting.where(name: 'last_league_fetch').first.value
      return fetch_leagues_and_update_db unless last_fetch_time.present?

      if Time.parse(last_fetch_time).utc > 1.hour.ago
        get_leagues_from_db
      else
        fetch_leagues_and_update_db
      end
    end

    private

    def get_leagues_from_db
      year = Time.now.utc.year
      League.where('year >= ?', year)
    end

    def fetch_leagues_and_update_db
      response = connection.get("?key=#{Settings.results_api.key}&format=json&req=leagues")

      return get_leagues_from_db if response.status != 200

      AppSetting.first_or_create!(name: 'last_league_fetch').update_attributes!(value: Time.now.utc.to_s)

      League.save_leagues_from_json(response.body)
      get_leagues_from_db
    end

    def url
      "#{Settings.results_api.host}"
    end

    def connection
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger unless Rails.env == 'test'
        faraday.adapter  Faraday.default_adapter
      end
      conn
    end
  end
end
