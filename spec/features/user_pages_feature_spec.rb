require 'rails_helper'

describe "User pages" do
  include FeatureSpecHelpers

  describe "A user's page" do
    let(:user) { create(:user) }

    describe "when signed in" do
      before do
        visit signin_path
        sign_in_user(user)
      end

      it "displays the first name of the user" do
        expect(page).to have_content(user.first_name)
      end
    end
  end

  describe "index of registered users" do
    let!(:signed_in_user) { create(:user) }

    before do
      visit signin_path
      sign_in_user(signed_in_user)
      visit users_path
    end

    subject { page }

    it { is_expected.to have_title('All Users') }
    it { is_expected.to have_content('All Users') }

    #describe "pagination" do
    #  before(:all) do
    #    30.times { create(:user) }
    #  end
    #
    #  after(:all) do
    #    User.delete_all
    #  end
    #
    #  it "should list each user" do
    #    User.order(:first_name).page(page: 1).each do |user|
    #      expect(page).to have_selector('li', text: "#{user.first_name} #{user.last_name} (#{user.email})")
    #    end
    #  end
    #
    #  it "should not list the signed in user" do
    #    expect(page).not_to have_selector('li', text: "#{signed_in_user.first_name} #{signed_in_user.last_name} (#{signed_in_user.email})")
    #  end
    #end
  end
end
