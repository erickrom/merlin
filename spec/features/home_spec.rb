require 'spec_helper'

describe "Home page" do

  it "should have the content 'Welcome Futbol Wizards!'" do
    visit '/home'
    expect(page).to have_content('Welcome Futbol Wizards!')
  end

  it "should have the title 'Futbol Merlin | Home'" do
    visit '/home'
    expect(page).to have_title('Futbol Merlin | Home')
  end
end
