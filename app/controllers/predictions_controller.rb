class PredictionsController < SessionRequiredController
  def new
    #puts params.inspect
    puts "inside new predictions controller"
    @match_id = params[:match_id]
    match = Match.find_by(id: @match_id)

    tournament_id = params[:tournament_id]
    puts "tournament id: #{tournament_id}"
    tournament = Tournament.find_by(id: tournament_id)
    @prediction = Prediction.new(match: match, tournament: tournament)
  end

  def create
    puts "params in create prediction: #{params.inspect}"
    prediction = Prediction.new(prediction_params)
    prediction.user = current_user

    prediction.save!

    puts "after save, prediction: #{prediction.reload.inspect}"

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private
  def prediction_params
    params.require(:prediction).permit(:local_goals, :visitor_goals,
                                       :match_id, :tournament_id)
  end
end
