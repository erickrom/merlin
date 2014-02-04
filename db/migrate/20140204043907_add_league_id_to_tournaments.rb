class AddLeagueIdToTournaments < ActiveRecord::Migration
  def change
    change_table :tournaments do |t|
      t.references :league
    end
  end
end
