class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant
  before_action :restaurant_has_order_in_creation?, only: [:new, :create]
  before_action :set_order_and_validate_user, only: [:show, :confirming, :preparing,
                                                     :done, :delivered, :canceled]


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

  def show; end

  def confirming
    @order.confirming!
    redirect_to @order, notice: 'Pedido enviado para a cozinha.'
  end

  def preparing
    @order.preparing!
    redirect_to @order, notice: 'Pedido foi confirmado e está sendo preparado.'
  end

  def done
    @order.done!
    redirect_to @order, notice: 'Pedido pronto para a entrega.'
  end

  def delivered
    @order.delivered!
    redirect_to @order, notice: 'Pedido entregue com sucesso.'
  end

  def canceled
    @order.canceled!
    redirect_to @order, alert: 'Pedido cancelado.'
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

  def restaurant_has_order_in_creation?
    @order_in_creation = @restaurant.orders.find_by(status: :creating)
    redirect_to orders_path, 
      alert: 'É permitido ter apenas um pedido com status: Em criação.' if @order_in_creation
  end

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_email,
                                  :customer_social_number)
  end
end