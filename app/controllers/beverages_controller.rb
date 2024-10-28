class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_beverage, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant, only: [:create]
  before_action :validate_current_user, only: [:show, :edit, :update, :destroy]

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new(beverage_params)
    @beverage.restaurant = @restaurant

    if @beverage.save
      redirect_to beverage_path(@beverage), notice: 'Bebida registrada com sucesso!'
    else
      flash.now[:alert] = 'Falha ao registrar bebida.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @beverage.update(beverage_params)
      redirect_to @beverage, notice: 'Bebida editada com sucesso!'
    else
      flash.now[:alert] = 'Falha ao editar bebida.'
      render 'edit'
    end
  end

  def show; end

  def destroy
    @beverage.destroy
    redirect_to items_path, notice: 'Bebida removida com sucesso!'
  end

  private
  
  def validate_current_user
    beverage = Beverage.find(params[:id])
    unless beverage.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar essa bebida'
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end

  def beverage_params
    params.require(:beverage).permit(:type, :name, :description,
                                     :calories, :alcoholic, :image)
  end
end