class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.references :tournament
      t.references :user
      t.references :match
      t.integer :local_goals
      t.integer :visitor_goals

      t.timestamps
    end

    add_index(:predictions, :tournament_id)
    add_index(:predictions, [:tournament_id, :match_id], :name => 'index_predictions_on_tournament_and_match' )
  end
end
