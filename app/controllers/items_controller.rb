class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_and_items, only: [:index]
  before_action :set_item, only: [:show]
  before_action :validate_current_user, only: [:show]

  def index
    
  end
  def show

  end


  private

  def set_restaurant_and_items
    @restaurant = current_user.restaurant
    @items = @restaurant.items
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def validate_current_user
    item = Item.find(params[:id])
    unless item.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse item'
    end
  end

  def item_params
    params.require(:item).permit(:type, :name, :description,
                                 :alcoholic, :calories, :image)
  end
end