require 'spec_helper'

describe SessionsController do
  include SessionsHelper

  let(:user) { create(:user) }

  describe "POST create" do
    let(:remember_token) { 'some-unique-remember-token' }

    before do
      User.stub(:new_remember_token).and_return(remember_token)
    end

    def make_request
      post :create, params
    end

    context "with valid params" do
      let(:params) { {
        session: {
          email: user.email,
          password: user.password
        }
      }}

      it "creates a cookie with a remember token and saves it encrypted in the user" do
        make_request
        expect(cookies.permanent[:remember_token]).to eq(remember_token)
        expect(user.reload.remember_token).to eq(User.encrypt(remember_token))
      end

      it "sets the current_user" do
        make_request
        expect(current_user).to eq(user)
      end
    end

    context "with invalid params" do
      let(:params) { {
        session: {
          email: 'no-one@example.com',
          password: 'invalid'
        }
      }}

      it "shows an error message" do
        make_request
        expect(flash.now[:error]).to eq("Invalid email/password combination")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      sign_in_user user
    end

    def make_request
      delete :destroy
    end

    it "removes the user cookie" do
      make_request
      expect(cookies[:remember_token]).to be_nil
    end
  end
end
