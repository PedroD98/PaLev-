class PreRegistersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?

  def index
    @pre_registers = current_user.pre_registers
  end
end