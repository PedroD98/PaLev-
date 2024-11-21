class DiscountsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?
  before_action :set_restaurant_and_discounts
  before_action :set_discount, only: [:show, :edit, :update]

  def index
    @discounts = @discounts.select(&:is_discount_valid?)  if @discounts.any?
  end

  def list; end

  def new
    @discount = Discount.new
  end

  def create
    @discount = @restaurant.discounts.create(discount_params)
    
    
    if @discount.save && validate_user
      redirect_to @discount, notice: 'Desconto criado com sucesso!'
      
    else
      flash.now[:alert] = 'Falha ao criar desconto.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @discount.update(discount_params)
      redirect_to @discount, notice: 'Porções do desconto atualizadas com sucesso!'
    else
      @items = @restaurant.items
      flash.now[:alert] = 'Falha em atualizar desconto'
      render 'edit'
    end
  end
  
  def show; end

  private

  def validate_user
    if @discount.restaurant != current_user.restaurant
      redirect_to root_path, alert: 'Apenas o dono do estabelecimento pode criar descontos.'
      return false
    end
    true
  end

  def set_restaurant_and_discounts
    @restaurant = current_user.restaurant
    @discounts = @restaurant.discounts
    @items = @restaurant.items
  end
  
  def set_discount
    @discount = Discount.find(params[:id])
    unless @discount.restaurant == current_user.restaurant
      redirect_to discounts_path, alert: 'Você não pode acessar essa página.'
    end
  end

  def discount_params
    params.require(:discount).permit(:name, :discount_amount, :starting_date,
                                     :ending_date, :max_use, portion_ids: [])
  end
end