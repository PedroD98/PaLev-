class ChangeOpenTimeAndCloseTimeToTimeInOperatingHours < ActiveRecord::Migration[7.2]
  def change
    change_column :operating_hours, :open_time, :time
    change_column :operating_hours, :close_time, :time
  end
end
