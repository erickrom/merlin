class TournamentsController < SessionRequiredController
  before_filter :check_user_in_tournament, only: [:show]

  def new
    @user = current_user
    @leagues = ResultadosFutbol.get_current_leagues
    @tournament = Tournament.new
  end

  def create
    tournament_data = params["tournament"]
    user = current_user
    @tournament = Tournament.create!(name: tournament_data["name"], user: user, league_id: tournament_data["league"])
    flash[:success] = "Created New Tournament #{@tournament.name}"
    redirect_to @tournament
  end

  def show
  end

  private

  def check_user_in_tournament
    @tournament = Tournament.where(id: params[:id]).first
    user = current_user
    redirect_to user_path(current_user) unless @tournament.is_user_in_tournament?(user)
  end
end
