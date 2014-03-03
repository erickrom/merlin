module FutbolResultadosRequestStubs
  def stub_leagues_request(status = 200, options = {})
    stub_request(:get, "#{Settings.results_api.host}/scripts/api/api.php?key=#{Settings.results_api.key}&format=json&req=leagues").
      to_return(status: status, body: load_fixture('leagues_response', 'json'))
  end

  def expect_leagues_request
    WebMock.should have_requested(:get, "#{Settings.results_api.host}/scripts/api/api.php?key=#{Settings.results_api.key}&format=json&req=leagues")
  end

  def stub_matches_request(status = 200, options = {})
    params = "?key=#{Settings.results_api.key}&format=json&req=matchs&league=#{options[:league]}"
    params = params + "&round=#{options[:round]}" if options[:round].present?
    params = params + "&group=#{options[:group]}" if options[:group].present?
    stub_request(:get, "#{Settings.results_api.host}/scripts/api/api.php#{params}").
      to_return(status: status, body: load_fixture('matches_response', 'json'))
  end

  def expect_matches_request(options = {})
    params = "?key=#{Settings.results_api.key}&format=json&req=matchs&league=#{options[:league]}"
    params = params + "&round=#{options[:round]}" if options[:round].present?
    params = params + "&group=#{options[:group]}" if options[:group].present?
    WebMock.should have_requested(:get, "#{Settings.results_api.host}/scripts/api/api.php#{params}")
  end
end

