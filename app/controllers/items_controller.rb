class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?
  before_action :set_restaurant_items_and_tags, only: [:index, :search, :filter]
  before_action :set_item_and_validate_current_user, only: [:show, :deactivated, :activated]
  def index; end

  def show; end

  def search
    @search_input = params[:query]
    @searched_items = @items.where(["name LIKE ? or description LIKE ?",
                                    "%#{@search_input}%", "%#{@search_input}%"])
  end

  def filter
    return redirect_to items_path if params[:tag_filter_ids].last.blank?
    filter_inputs = params[:tag_filter_ids].reject(&:blank?)
    @filters = @restaurant.tags.where(id: filter_inputs)

    filtered_items = @items.select do |item|
      @filters.all? { |tag| item.tags.include?(tag)}
    end

    @items = filtered_items
  end

  def activated
    @item.activated!
    redirect_to item_path(@item), notice: 'O item foi ativado.'
  end
  
  def deactivated
    @item.deactivated!
    redirect_to item_path(@item), notice: 'O item foi desativado.'
  end

  private

  def set_restaurant_items_and_tags
    @restaurant = current_user.restaurant
    @items = @restaurant.items
    @tags = @restaurant.tags
  end

  
  def set_item_and_validate_current_user
    @item = Item.find(params[:id])
    unless @item.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse item'
    end
  end
end