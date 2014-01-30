class TournamentsController < ApplicationController
  def new
    @user = current_user
    @leagues = ResultadosFutbol.get_current_leagues
  end
end
