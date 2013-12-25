require 'spec_helper'


describe "Home page" do
  subject { page }

  before do
    visit root_path
  end

  it { should have_content('Welcome Futbol Wizards!') }
  it { should have_title('Futbol Merlin | Home') }

  describe "Signup Button" do
    it "takes you to the signup page" do
      click_link "Sign up"
      expect(page).to have_title('Futbol Merlin | Sign up')
      expect(page).to have_button("Create account")
    end
  end
end
