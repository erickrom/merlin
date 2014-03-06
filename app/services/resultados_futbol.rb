class ResultadosFutbol
  class << self
    def get_leagues
      connection.get("?key=#{Settings.results_api.key}&format=json&req=leagues")
    end

    def get_matches(league, group, round)
      response = fetch_matches(league, group, round)
      response.body
    end

    private

    def fetch_matches(league, group, round)
      params = "?key=#{Settings.results_api.key}&format=json&req=matchs&league=#{league}"
      params = params + "&round=#{round}" if round.present?
      params = params + "&group=#{group}" if group.present?
      connection.get(params)
    end

    def url
      "#{Settings.results_api.host}/scripts/api/api.php"
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
