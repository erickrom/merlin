class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :league
      t.integer :group
      t.integer :round
      t.string :local
      t.string :visitor
      t.string :local_shield
      t.string :visitor_shield
      t.datetime :schedule
      t.string :local_goals
      t.string :visitor_goals

      t.timestamps
    end
  end
end
