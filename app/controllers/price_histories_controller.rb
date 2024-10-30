class PriceHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_item_and_portion
  before_action :validate_user

  def index
    @price_histories = @portion.price_histories
  end
  
  private

  def set_item_and_portion
    @item = Item.find(params[:item_id])
    @portion = Portion.find(params[:portion_id])
  end

  def validate_user
    unless @item.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse histórico de preços.'
    end
  end
end