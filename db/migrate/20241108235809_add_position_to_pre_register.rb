class AddPositionToPreRegister < ActiveRecord::Migration[7.2]
  def change
    add_reference :pre_registers, :position, null: false, foreign_key: true
  end
end
