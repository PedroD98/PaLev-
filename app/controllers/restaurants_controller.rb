class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant, only: [:show]
  before_action :user_has_registered_restaurant?, only: [:show]
  before_action :validate_current_user, only: [:show]
  
  def new
    if current_user.registered_restaurant
      redirect_to current_user.restaurant, notice: 'Já existe um restaurante vinculado à essa conta.'
    end
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user

    if @restaurant.save
      current_user.update(registered_restaurant: true)
      redirect_to @restaurant, notice: 'Restaurante registrado com sucesso.'
    else
      flash.now[:alert] = 'Falha ao registrar restaurante.'
      render 'new', status: :unprocessable_entity
    end
  end
  
  def show
    @restaurant.update_operation_status
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def validate_current_user
    if @restaurant.user != current_user
      redirect_to current_user.restaurant, alert: 'Você não tem acesso à esse restaurante.'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:legal_name, :restaurant_name, :registration_number,
                                       :address, :phone_number, :email)
  end
end