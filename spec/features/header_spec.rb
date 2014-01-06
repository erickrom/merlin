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

  describe "when signed in" do
    include FeatureSpecHelpers

    let(:user) { create(:user) }

    before do
      visit signin_path
      sign_in(user)
    end

    it "shows the right links" do
      expect(page).to have_link('Users', href: users_path)
    end
  end
end
