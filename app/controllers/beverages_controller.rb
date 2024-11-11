class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?
  before_action :set_restaurant, only: [:create]
  before_action :set_beverage_and_validate_current_user, only: [:edit, :update, :destroy]

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new(beverage_params)
    @beverage.restaurant = @restaurant

    if @beverage.save
      redirect_to item_path(@beverage), notice: 'Bebida registrada com sucesso!'
    else
      flash.now[:alert] = 'Falha ao registrar bebida.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @beverage.update(beverage_params)
      redirect_to item_path(@beverage), notice: 'Bebida editada com sucesso!'
    else
      flash.now[:alert] = 'Falha ao editar bebida.'
      render 'edit'
    end
  end

  def destroy
    @beverage.portions.destroy_all
    @beverage.destroy
    redirect_to items_path, notice: 'Bebida removida com sucesso!'
  end


  private
  
  def set_beverage_and_validate_current_user
    @beverage = Beverage.find(params[:id])
    unless @beverage.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar essa bebida'
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end
  
  def beverage_params
    params.require(:beverage).permit(:type, :name, :description,
                                     :calories, :alcoholic, :image)
  end
end