class SessionRequiredController < ApplicationController
  before_action :signed_in_user

  include SessionsHelper

  # Before Filters
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
end
