class CreateDishTags < ActiveRecord::Migration[7.2]
  def change
    create_table :dish_tags do |t|
      t.references :item, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
