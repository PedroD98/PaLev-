class ChangePriceInPortions < ActiveRecord::Migration[7.2]
  def change
    change_column :portions, :price, :decimal
  end
end
