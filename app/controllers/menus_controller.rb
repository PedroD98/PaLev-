class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_and_validate_user
  before_action :set_menu, only: [:show]

  def index
    @menus = @restaurant.menus
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = @restaurant.menus.create(menu_params)

    if @menu.save
      redirect_to restaurant_menu_path(@restaurant, @menu), notice: 'Cardápio cadastrado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao cadastrar cardápio.'
      render 'new', status: :unprocessable_entity
    end
    
  end

  def show; end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def set_restaurant_and_validate_user
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant != current_user.restaurant
      redirect_to restaurant_path, alert: 'Você não pode acessar essa página.'
    end
  end

  def menu_params
    params.require(:menu).permit(:name)
  end
end