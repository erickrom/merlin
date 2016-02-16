class PredictionsController < SessionRequiredController
  after_filter :prepare_unobtrusive_flash
  include SessionsHelper

  def new
    @match_id = params[:match_id]
    match = Match.find_by(id: @match_id)

    tournament_id = params[:tournament_id]
    @tournament = Tournament.find_by(id: tournament_id)
    @prediction = Prediction.where(match: match, tournament: @tournament).first_or_initialize
  end

  def create
    puts "prediction params: #{prediction_params.inspect}"
    @prediction = Prediction.new(prediction_params)
    @prediction.user = current_user

    if @prediction.save
      flash[:success] = 'Prediction saved successfully'
      render json: {"prediction": @prediction, "user_name": @prediction.user.first_name}
    else
      render json: @prediction.errors, status: :unprocessable_entity
    end
  end

  def update
    @prediction = Prediction.find(params[:id])
    @prediction.update_attributes!(prediction_params)

    flash[:success] = 'Prediction saved successfully'

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :create }
    end
  end

  private
  def prediction_params
    params.require(:prediction).permit(:local_goals, :visitor_goals,
                                       :match_id, :tournament_id)
  end
end
