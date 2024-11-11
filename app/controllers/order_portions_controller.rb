class OrderPortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant_order_and_validate_status
  before_action :is_restaurant_open?
  before_action :validate_user
  before_action :set_portion
  before_action :set_order_portion, only: [:edit, :update]

  def new
    @order_portion = OrderPortion.new
  end

  def create
    @order_portion = @order.order_portions.create(order_portion_params)
    @order_portion.portion = @portion

    if @order_portion.save && @order.creating?
      redirect_to @order,
      notice: 'Item adicionado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao adicionar item.'
      render 'new', status: :unprocessable_entity

    end
  end

  def edit; end

  def update
    if @order_portion.update(order_portion_params) && @order.creating?
      redirect_to @order,
      notice: 'Item do pedido atualizado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao atualizar item do pedido.'
      render 'edit', status: :unprocessable_entity
    end
  end


  private

  def set_restaurant_order_and_validate_status
    @order = Order.find(params[:order_id])
    @restaurant = @order.restaurant

    redirect_to @order,
    alert: 'Essa ação não está disponível para pedidos que não estão em fase de criação.' unless @order.creating?
  end

  def set_portion
    @portion = Portion.find(params[:portion_id])
  end
  
  def set_order_portion
    @order_portion = OrderPortion.find(params[:id])
  end

  def validate_user
    if @restaurant != current_user.restaurant
      redirect_to root_path, alert: 'Você não pode acessar essa página.'
    end
  end

  def is_restaurant_open?
    @restaurant.update_operation_status
    if @restaurant.closed?
      redirect_to orders_path, alert: 'O restaurante está fechado no momento.'
    end
  end

  def order_portion_params
    params.require(:order_portion).permit(:portion_id, :qty, :description)
  end
end