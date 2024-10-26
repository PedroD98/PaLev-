class CreateOperatingHours < ActiveRecord::Migration[7.2]
  def change
    create_table :operating_hours do |t|
      t.integer :day_of_week
      t.time :open_time
      t.time :close_time
      t.boolean :closed, default: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
