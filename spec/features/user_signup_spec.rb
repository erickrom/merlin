require 'spec_helper'

describe "Signing up" do
  before do
    visit signup_path
  end

  describe "signup page" do
    it "has the Sign up title" do
      expect(page).to have_content('Sign up')
      expect(page).to have_title('Sign up')
    end
  end

  describe "with invalid data" do
    it "should not create a new user" do
      expect { click_button "Create account" }.not_to change { User.count }
    end

    it "should display the error messages" do
      click_button "Create account"
      expect(page).to have_content("The form contains 7 errors")
    end
  end

  describe "with valid data" do
    before do
      fill_in "First Name", with: "Erick"
      fill_in "Last Name", with: "Romero"
      fill_in "Email", with: "me@example.com"
      fill_in "Password", with: "foobar"
      fill_in "Confirmation", with: "foobar"
    end

    it "should create a new user" do
      expect { click_button "Create account" }.to change { User.count }.by(1)
    end

    it "should show the welcome message" do
      click_button "Create account"
      expect(page).to have_content("#{User.last.first_name}, Welcome to Futbol Merlin!")
    end

    it "shows the user as signed in" do
      click_button "Create account"
      expect(page).to have_link('Sign out')
      expect(page).to have_title("Futbol Merlin | Erick")
    end
  end
end
