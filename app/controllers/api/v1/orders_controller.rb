class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_restaurant
  before_action :set_order_and_items, only: [:show]

  def index
    @orders = Order.all.where(restaurant_id: @restaurant.id)
    filter_orders if params[:status_filters]
    render status: 200, json: @orders
  end

  def show
    render status: 400, json: { message: 'O pedido está vazio'} if @order_portions.empty?
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(code: params[:restaurant_code])
    render status: 404, json: { error: 'Restaurante não encontrado' } if @restaurant.nil?
  end

  def filter_orders
    @orders = @orders.where(status: params[:status_filters]) if validate_status_params
  end

  def validate_status_params
    params[:status_filters].each do |filter|
      return false unless Order.statuses.keys.include?(filter)
    end
  end

  def set_order_and_items
    @order = @restaurant.orders.find_by(code: params[:order_code])
    return render status: 404, json: { error: 'Pedido não encontrado'} if @order.nil?

    @order_portions = @order.order_portions
  end
end