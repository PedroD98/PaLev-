class RenameColumnInOrders < ActiveRecord::Migration[7.2]
  def change
    rename_column :orders, :customer_registration_number, :customer_social_number
    rename_column :orders, :cutomer_name, :customer_name
  end
end
