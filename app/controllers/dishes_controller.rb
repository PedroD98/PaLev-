class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_dish_and_validate_current_user, only: [:edit, :update, :destroy]
  before_action :handle_tag_ids, only: [:create, :update]

  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant = @restaurant

    if @dish.save && @new_tag_errors.empty?
      redirect_to item_path(@dish), notice: 'Prato registrado com sucesso!'
    else
      @tags = @restaurant.tags
      flash.now[:alert] = 'Falha ao registrar prato.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @dish.update(dish_params) && @new_tag_errors.empty?
      redirect_to item_path(@dish), notice: 'Prato editado com sucesso!'
    else
      @tags = @restaurant.tags
      flash.now[:alert] = 'Falha ao editar prato.'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @dish.portions.destroy_all
    @dish.destroy
    redirect_to items_path, notice: 'Prato removido com sucesso!'
  end

  private

  def set_dish_and_validate_current_user
    @dish = Dish.find(params[:id])
    unless @dish.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse prato'
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
    @tags = @restaurant.tags
  end

  def dish_params
    params.require(:dish).permit(:type, :name, :description, :calories,
                                 :image, tag_ids: [])
  end

  def handle_tag_ids
    original_tag_params = params[:dish][:tag_ids].reject(&:blank?)
    @new_tag_params = []
    @new_tag_errors = []

    original_tag_params.each do |param|

      if param.to_s.match?(/\A\d+\z/)
        find_tag_by_id(param)
      else
        find_or_create_tag_by_name(param)
      end
    end
    params[:dish][:tag_ids] = @new_tag_params
  end

  def find_tag_by_id(param)
    tag = @restaurant.tags.find_by(id: param.to_i)
    return @new_tag_params << tag.id if tag && !@new_tag_params.include?(tag.id)

    @new_tag_errors << "Marcadores devem conter apenas letras e espaços."
  end

  def find_or_create_tag_by_name(param)
    tag = @restaurant.tags.find_by(name: param.capitalize)
    return @new_tag_params << tag.id if tag && !@new_tag_params.include?(tag.id)

    new_tag = @restaurant.tags.new(name: param)
    if new_tag.valid?
      new_tag.save
      @new_tag_params << new_tag.id
    else
      @new_tag_errors << "Novo marcador inválido."
    end
  end
end