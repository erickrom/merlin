shared_examples_for 'an action that requires a signed-in user' do
  before do
    sign_out
  end

  it "redirects to the sign in page" do
    expect(make_request).to redirect_to(signin_url)
  end
end