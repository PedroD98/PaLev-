class AddCancelReasonToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :cancel_reason, :string
  end
end
