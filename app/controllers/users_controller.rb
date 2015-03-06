class UsersController < SessionRequiredController
  skip_before_action :signed_in_user, only: [:new, :create]
  before_filter :correct_user, only: [:show]

  layout "user_main", except: [:index, :new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in_user @user
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
    #@users = User.where.not(id: current_user.id)
    @users = User.order(:first_name).page params[:page]
    #@users = User.paginate(page: params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
