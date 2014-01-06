class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :index]
  before_filter :correct_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "#{@user.first_name}, Welcome to Futbol Merlin!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def index
    @all_users = User.where.not(id: current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
