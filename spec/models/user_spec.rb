require 'spec_helper'

describe User do

  before do
    @user = User.new(first_name: "John", last_name: "Doe",
                     email: "john@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "associations" do
    it { should have_many(:tournaments) }
  end

  describe "first and last name validations" do
    describe "when name is not present" do
      before { @user.first_name = " " }
      it { should_not be_valid }
    end

    describe "when first_name is too long" do
      before { @user.first_name = "a" * 51 }
      it { should_not be_valid }
    end

    describe "when last_name is too long" do
      before { @user.last_name = "a" * 51 }
      it { should_not be_valid }
    end
  end

  describe "email validations" do
    it "saves email addresses in lowercase" do
      up_case_user = create(:user, email: 'sOmETHing@EXamPle.coM')
      expect(up_case_user.email).to eq('something@example.com')
    end

    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end
  end

  describe "password validations" do
    describe "when password is not present" do
      before do
        @user = User.new(first_name: "John", last_name: "Doe", password: " ", password_confirmation: " ")
      end

      it { should_not be_valid }

      describe "with a password that's too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid }
      end
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end
  end

  describe "#authenticate" do
    let(:found_user) { User.find_by(email: @user.email) }

    before { @user.save }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }

    it "should not have a blank remember token" do
      expect(@user.remember_token).not_to be_blank
    end
  end
end
