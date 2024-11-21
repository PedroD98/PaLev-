class AddRemainingUsesToDiscount < ActiveRecord::Migration[7.2]
  def change
    add_column :discounts, :remaining_uses, :integer
  end
end
