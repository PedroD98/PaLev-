class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_restaurant

  def index
    @orders = Order.all.where(restaurant_id: @restaurant.id)
    filter_orders if params[:status_filters]
    render status: 200, json: @orders
  end

  private

  def set_restaurant
    if params[:restaurant_code]
      @restaurant = Restaurant.find_by(code: params[:restaurant_code])
    end
    render status: 404, json: { error: 'Restaurante não encontrado' } if @restaurant.nil? || !params[:restaurant_code]
  end

  def filter_orders
    if validate_status_params
      @orders = @orders.where(status: params[:status_filters])
    end
  end

  def validate_status_params
    params[:status_filters].each do |filter|
      return true if Order.statuses.keys.include?(filter)
    end

    false
  end
end