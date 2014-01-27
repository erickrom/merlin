class HomeController < ApplicationController
  skip_before_action :signed_in_user
  def home
  end
end
