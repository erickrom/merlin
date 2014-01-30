module LoadFixtureHelper
  def self.fixture_path=(path)
    @path = path
  end

  def self.load_fixture(fixture_name, ext="xml", options={})
    fixtures_path = Pathname(@path)
    erb_path = fixtures_path.join("#{fixture_name}.#{ext}.erb")
    plain_path = fixtures_path.join("#{fixture_name}.#{ext}")
    if File.exists?(erb_path)
      Erubis::Eruby.new(File.read(erb_path)).result(options)
    else
      File.read(plain_path)
    end
  end

  def load_fixture(*args)
    LoadFixtureHelper.load_fixture(*args)
  end
end
