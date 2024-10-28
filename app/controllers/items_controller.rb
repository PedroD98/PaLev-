class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_and_items, only: [:index, :search]
  before_action :set_item, only: [:deactivated, :activated]
  def index; end

  def search
    @search_input = params[:query]
    @searched_items = @items.where(["name LIKE ? or description LIKE ?",
                                    "%#{@search_input}%", "%#{@search_input}%"])
  end

  def activated
    @item.activated!
    redirect_to @item, notice: 'O item foi ativado.'
  end
  
  def deactivated
    @item.deactivated!
    redirect_to @item, notice: 'O item foi desativado.'
  end

  private

  def set_restaurant_and_items
    @restaurant = current_user.restaurant
    @items = @restaurant.items
  end

  def set_item
    @item = Item.find(params[:id])
  end
end