class PriceHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_and_item, only: [:show, :details]
  before_action :validate_user, only: [:show, :details]

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    validate_user
    @price_histories = @restaurant.price_histories
  end

  def show
    @price_histories = @item.price_histories
  end

  def details
    @portion = Portion.find(params[:portion_id])
    @price_histories = @portion.price_histories
  end
  
  private

  def set_restaurant_and_item
    @item = Item.find(params[:item_id])
    @restaurant = @item.restaurant
  end

  def validate_user
    unless @restaurant.user == current_user
      redirect_to items_path, alert: 'Você não pode acessar esse histórico de preços.'
    end
  end
end