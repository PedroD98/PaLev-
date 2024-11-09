class PreRegistersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant, only: [:new]
  before_action :validate_user, only: [:create]

  def index
    @pre_registers = current_user.pre_registers
  end

  def new
    @pre_register = PreRegister.new
  end

  def create
    @pre_register = current_user.pre_registers.create(pre_register_params)
    @pre_register.restaurant = current_user.restaurant
    if @pre_register.save
      redirect_to pre_registers_path, notice: 'Pré-cadastro criado com sucesso!'
    else
      set_restaurant
      flash.now[:alert] = 'Falha ao criar pré-cadastro.'
      render 'new', status: :unprocessable_entity
    end
  end

  private 

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def validate_user
    position = Position.find_by(id: params[:pre_register][:position_id])
  
    if position.restaurant != current_user.restaurant || !position
      redirect_to root_path, alert: 'Apenas o dono do restaurante pode criar pré-cadastros.'
    end
  end

  def pre_register_params
    params.require(:pre_register).permit(:employee_social_number, :employee_email, :position_id)
  end
end