class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_and_validate_user
  before_action :set_order, only: [:show]


  def index
    @orders = @restaurant.orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = @restaurant.orders.create(order_params)

    if @order.save
      redirect_to restaurant_order_path(@restaurant, @order),
      notice: 'Pedido criado com sucesso!'
    else
      flash.now[:alert] = 'Falha em criar pedido.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  private

  def set_restaurant_and_validate_user
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant != current_user.restaurant
      redirect_to root_path, alert: 'Você não pode acessar essa página.' 
    end
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_email,
                                  :customer_social_number)
  end
end