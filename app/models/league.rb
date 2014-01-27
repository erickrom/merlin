class League < ActiveRecord::Base


  class << self
    def get_current_leagues
      []
    end
  end
end
