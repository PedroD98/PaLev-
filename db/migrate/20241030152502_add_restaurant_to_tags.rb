class AddRestaurantToTags < ActiveRecord::Migration[7.2]
  def change
    add_reference :tags, :restaurant, null: false, foreign_key: true
  end
end
