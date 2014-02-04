module FutbolResultadosRequestStubs
  def stub_leagues_request(status = 200, options = {})
    stub_request(:get, "#{Settings.results_api.host}/scripts/api/api.php?key=#{Settings.results_api.key}&format=json&req=leagues").
      to_return(status: status, body: load_fixture('leagues_response', 'json'))
  end

  def expect_leagues_request
    WebMock.should have_requested(:get, "#{Settings.results_api.host}/scripts/api/api.php?key=#{Settings.results_api.key}&format=json&req=leagues")
  end
end

