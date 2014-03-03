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
      t.integer :local_goals
      t.integer :visitor_goals

      t.timestamps
    end
  end
end
