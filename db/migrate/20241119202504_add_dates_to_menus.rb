class AddDatesToMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :menus, :starting_date, :datetime
    add_column :menus, :ending_date, :datetime
  end
end
