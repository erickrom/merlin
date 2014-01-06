module FeatureSpecHelpers
  def sign_in(user)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
