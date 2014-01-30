class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.string :name, null: false
      t.string :value

      t.timestamps
    end

    add_index :app_settings, :name
  end
end
