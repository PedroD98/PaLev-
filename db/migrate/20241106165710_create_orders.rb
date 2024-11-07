class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :code
      t.integer :status, default: 0
      t.string :cutomer_name
      t.string :customer_phone
      t.string :customer_email
      t.string :customer_registration_number

      t.timestamps
    end
  end
end
