require 'spec_helper'

describe "User pages" do
  include FeatureSpecHelpers

  describe "A user's page" do

    let(:user) { create(:user) }

    describe "when signed in" do
      before do
        visit signin_path
        sign_in(user)
      end

      it "displays the first name of the user" do
        expect(page).to have_content(user.first_name)
      end
    end
  end

  describe "index of registered users" do
    let!(:signed_in_user) { create(:user) }
    let!(:other_user_1) { create(:user) }
    let!(:other_user_2) { create(:user) }

    before do
      visit signin_path
      sign_in(signed_in_user)
      visit users_path
    end

    subject { page }

    it { should have_title('All Users') }
    it { should have_content('All Users') }

    it "should list each user" do
      expect(page).to have_selector('li', text: "#{other_user_1.first_name} #{other_user_1.last_name} (#{other_user_1.email})")
      expect(page).to have_selector('li', text: "#{other_user_2.first_name} #{other_user_2.last_name} (#{other_user_2.email})")
    end

    it "should not list the signed in user" do
      expect(page).not_to have_selector('li', text: "#{signed_in_user.first_name} #{signed_in_user.last_name} (#{signed_in_user.email})")
    end
  end
end
