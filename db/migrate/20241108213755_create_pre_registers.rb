class CreatePreRegisters < ActiveRecord::Migration[7.2]
  def change
    create_table :pre_registers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.string :employee_email
      t.string :employee_social_number
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
