class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_dish, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant, only: [:create]
  before_action :validate_current_user, only: [:show, :edit, :update, :destroy]

  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant = @restaurant

    if @dish.save
      redirect_to dish_path(@dish), notice: 'Prato registrado com sucesso!'
    else
      flash.now[:alert] = 'Falha ao registrar prato.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    
  end

  def update
    if @dish.update(dish_params)
      redirect_to @dish, notice: 'Prato editado com sucesso!'
    else
      flash.now[:alert] = 'Falha ao editar prato.'
      render 'edit'
    end
    
  end

  def show
    
  end

  def destroy
    @dish.destroy
    redirect_to items_path, notice: 'Prato removido com sucesso!'
  end

  private

  def validate_current_user
    dish = Dish.find(params[:id])
    unless dish.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse prato'
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(:type, :name, :description,
                                 :calories, :image)
  end
end