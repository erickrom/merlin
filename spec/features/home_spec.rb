require 'spec_helper'


describe "Home page" do
  subject { page }

  before do
    visit root_path
  end

  it { should have_content('Welcome Futbol Wizards!') }
  it { should have_title('Futbol Merlin | Home') }
end
