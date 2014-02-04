class TournamentsController < SessionRequiredController
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
end
