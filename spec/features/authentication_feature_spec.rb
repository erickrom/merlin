require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do
    before { visit signin_path }


    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Futbol Merlin"  }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      include FeatureSpecHelpers

      let(:user) { create(:user) }

      before do
        sign_in_user(user)
      end

      it "shows the user as signed in" do
        expect(page).to have_title("Futbol Merlin | #{user.first_name}")
        expect(page).to have_link('Sign out', href: signout_path)
        expect(page).not_to have_link('Sign in', href: signin_path)
      end

      describe "signing out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "when signed in" do
    include FeatureSpecHelpers

    let(:user) { create(:user) }

    before do
      visit signin_path
      sign_in_user(user)
    end

    it "doesn't let you look at other user's page" do
      other_user = create(:user)
      visit user_path(other_user)

      expect(page).not_to have_content(other_user.first_name)
    end
  end

  describe "when signed out" do
    describe "signin page" do
      before { visit signin_path }

      it { should have_content('Sign in') }
      it { should have_title('Sign in') }
    end

    it "should not let you look at a user's page and redirect to sign in" do
      user = create(:user)
      visit user_path(user)
      expect(page).not_to have_content(user.first_name)
      expect(page).to have_title('Sign in')
    end

    describe "Sign in link" do
      it "takes you to the signin page" do
        visit root_url
        click_link "Sign in"
        expect(page).to have_title('Futbol Merlin | Sign in')
      end
    end

    describe "visiting the user index" do
      before { visit users_path }
      it { should have_title('Sign in') }
    end
  end
end
