class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :legal_name
      t.string :restaurant_name
      t.string :registration_number
      t.string :address
      t.string :phone_number
      t.string :code
      t.integer :operation_status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
