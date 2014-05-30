class PredictionsController < ApplicationController
  def new
    #puts params.inspect
    @match_id = params[:match_id]
    @prediction = Prediction.new
  end
end
