class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?, only: [:new, :create, :edit, :update]
  before_action :set_restaurant_and_items
  before_action :set_menu_and_items, only: [:edit, :update, :show]
  before_action :validate_user
  before_action :set_dishes_and_beverages, only: [:edit, :update, :show]
  before_action :set_order, only: [:index, :show]

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

  def edit; end

  def update
    if handle_item_ids
      redirect_to restaurant_menu_path(@restaurant, @menu), notice: 'Itens adicionados com sucesso!'
      
    else
      set_dishes_and_beverages
      flash.now[:alert] = 'Falha ao adicionar itens.'
      render 'edit', status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_menu_and_items
    @menu = Menu.find(params[:id])
    @items = @restaurant.items
  end

  def set_restaurant_and_items
    @restaurant = current_user.restaurant
  end
  
  def set_dishes_and_beverages
    @dishes = @restaurant.items.where(type: 'Dish').where.not(id: @menu.items.pluck(:id))
    @beverages = @restaurant.items.where(type: 'Beverage').where.not(id: @menu.items.pluck(:id))
  end

  def set_order
    @order = @restaurant.orders.find_by(status: :creating)
  end

  def validate_user
    if params[:restaurant_id]  
      if Restaurant.find(params[:restaurant_id]) != current_user.restaurant
        redirect_to restaurant_path(current_user.restaurant), alert: 'Você não pode acessar essa página.'
      end
    end

    if @menu && @menu.restaurant != current_user.restaurant
      redirect_to root_path, alert: 'Você não pode acessar essa página.'
    end
  end

  def menu_params
    params.require(:menu).permit(:name, item_ids: [])
  end

  def handle_item_ids
    item_ids_params = params[:menu][:item_ids].reject(&:blank?)
    selected_items = @items.where(id: item_ids_params)

    selected_items.each do |item|
      @menu.items << item
    end
  end
end