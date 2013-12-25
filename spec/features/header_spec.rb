require 'spec_helper'

describe "Header" do
  describe "Main home link" do
    it "takes you to the home page from any page" do
      visit signin_path
      expect(page).not_to have_title('Futbol Merlin | Home')
      click_link "Futbol Merlin"
      expect(page).to have_title('Futbol Merlin | Home')
    end
  end

  describe "Sign in link" do
    it "takes you to the signin page" do
      visit root_url
      click_link "Sign in"
      expect(page).to have_title('Futbol Merlin | Sign in')
    end
  end
end
