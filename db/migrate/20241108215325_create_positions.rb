class CreatePositions < ActiveRecord::Migration[7.2]
  def change
    create_table :positions do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
