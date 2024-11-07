class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant
  before_action :set_order_and_validate_user, only: [:show]


  def index
    @orders = @restaurant.orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = @restaurant.orders.create(order_params)

    if @order.save
      redirect_to @order,
      notice: 'Pedido criado com sucesso!'
    else
      flash.now[:alert] = 'Falha em criar pedido.'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def set_order_and_validate_user
    @order = Order.find(params[:id])
    if @order.restaurant != current_user.restaurant
      redirect_to root_path, alert: 'Você não pode acessar essa página.' 
    end
  end

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_email,
                                  :customer_social_number)
  end
end