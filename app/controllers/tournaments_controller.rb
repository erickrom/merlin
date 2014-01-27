class TournamentsController < ApplicationController
  def new
    @user = current_user
    @leagues = League.get_current_leagues
  end
end
