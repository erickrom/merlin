require 'spec_helper'

describe UsersController do
  describe "GET new" do
    def make_request
      get :new
    end

    it "assigns a new user" do
      make_request
      assigns(:user).should be_a(User)
    end
  end

  describe "POST create" do
    def make_request
      post :create, params
    end

    describe "with valid parameters" do
      let(:params) { {user: {first_name: "John", last_name: "Smith",
                             email: "me@example.com", password: "foobar", password_confirmation: "foobar"}} }
      it "creates a new User" do
        expect { make_request }.to change { User.count }.by(1)
      end

      it "shows the flash welcome message" do
        make_request
        flash[:success].should == "John, Welcome to Futbol Merlin!"
      end
    end

    describe "with invalid parameters" do
      let(:params) { {user: {first_name: "", last_name: "",
                             email: "", password: "", password_confirmation: ""}} }

      it "doesn't create a new user" do
        expect { make_request }.not_to change { User.count }
      end

      it "renders the new user page" do
        expect(make_request).to render_template("new")
      end
    end
  end

  #describe "GET show" do
  #
  #  def make_request
  #    get :show, id: user.id
  #  end
  #
  #  describe "with a valid user" do
  #    let(:user) { create(:user) }
  #
  #    it "finds the user" do
  #      make_request
  #      assigns(:user).should be_a(User)
  #    end
  #  end
  #end
end
