class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :set_restaurant
  before_action :set_tag_and_validate_user, only: [:edit, :update, :destroy]

  def index
    @tags = @restaurant.tags
  end

  def new 
    @tag = Tag.new
  end

  def create
    @tag = @restaurant.tags.new(tag_params)

    if @tag.save
      redirect_to tags_path, notice: 'Marcador registrado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao registrar marcador.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: 'Marcador editado com sucesso!'
    
    else
      flash.now[:alert] = 'Falha ao editar marcador.'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: 'Marcador removido com sucesso!'
  end


  private
  
  def set_tag_and_validate_user
    @tag = Tag.find(params[:id])
    unless @tag.restaurant == current_user.restaurant
      redirect_to tags_path, alert: 'Você não pode acessar esses marcadores'
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end