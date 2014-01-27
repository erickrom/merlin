class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.integer :external_id, null: false
      t.integer :year, null: false
      t.integer :group_code, null: false
      t.boolean :playoff
      t.integer :current_round
      t.integer :total_group
      t.integer :total_rounds
      t.string :flag_url_path

      t.timestamps
    end

    add_index :leagues, :year
  end
end
