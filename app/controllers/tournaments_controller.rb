class TournamentsController < SessionRequiredController
  before_filter :check_user_in_tournament, only: [:show]

  layout "user_main"

  def new
    @user = current_user
    @leagues = LeagueFetcher.get_leagues
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
    @rounds = @tournament.league.total_rounds
    @current_round = params[:round].present? ? params[:round].to_i : @tournament.league.current_round
    @group = params[:group].present? && params[:group].to_i <= @tournament.league.total_group ? params[:group].to_i : 1
    @total_group = @tournament.league.total_group
    @matches = MatchFetcher.get_matches(@tournament.league, @group, @current_round)
  end

  private

  def check_user_in_tournament
    @tournament = Tournament.where(id: params[:id]).first
    user = current_user
    redirect_to user_path(current_user) unless @tournament.is_user_in_tournament?(user)
  end
end
