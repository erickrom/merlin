class AddLastLeagueFetchToAppSettings < ActiveRecord::Migration
  class AppSetting < ActiveRecord::Base
  end

  def change
    AppSetting.where(name: 'last_league_fetch').first_or_create!(value: nil)
  end
end
