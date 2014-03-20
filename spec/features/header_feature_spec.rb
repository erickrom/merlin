require 'spec_helper'

describe "Header" do
  describe "when signed in" do
    include FeatureSpecHelpers

    let(:user) { create(:user) }

    before do
      visit signin_path
      sign_in_user(user)
    end

    it "shows the right links" do
      expect(page).to have_link(user.first_name, href: user_path(user.id))
      expect(page).to have_link('Users', href: users_path)
      expect(page).to have_link('Futbol Merlin', href: user_path(user.id))
    end
  end

  describe "when not signed in" do
    describe "Main home link" do
      it "takes you to the home page from any page" do
        visit signin_path
        click_link "Futbol Merlin"
        expect(page).to have_title('Futbol Merlin | Home')
      end
    end
  end
end
