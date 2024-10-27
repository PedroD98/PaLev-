class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :calories
      t.boolean :alcoholic, default: false
      t.string :type

      t.timestamps
    end
  end
end
