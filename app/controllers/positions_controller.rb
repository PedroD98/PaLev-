class PositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?
  before_action :set_restaurant_and_validate_user

  def index
    @positions = @restaurant.positions.reject { | position | position.description == 'Dono' }
  end

  def new
    @position = Position.new
  end

  def create
    @position = @restaurant.positions.create(params.require(:position).permit(:description))
    @position.description.capitalize!

    if @position.save
      redirect_to restaurant_positions_path(@restaurant), notice: 'Cargo criado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao criar cargo.'
      render 'new', status: :unprocessable_entity
    end
  end

  private 

  def set_restaurant_and_validate_user
    @restaurant = current_user.restaurant
    if Restaurant.find(params[:restaurant_id]) != @restaurant
      redirect_to root_path, alert: 'Você não pode acessar essa página.'
    end
  end
end