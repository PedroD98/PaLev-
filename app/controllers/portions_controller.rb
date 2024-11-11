class PortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?
  before_action :set_item_and_validate_current_user
  before_action :set_portion, only: [:edit, :update]

  def new
    @portion = Portion.new
  end

  def create
    @portion = @item.portions.create(portion_params)
    if @portion.save
      create_price_history
      redirect_to item_path(@item), notice: 'Porção criada com sucesso!'

    else
      flash.now[:alert] = 'Falha ao cadastrar porção.'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    new_price = params.require(:portion).permit(:price)

    if @portion.update(price: new_price[:price]) && @portion.saved_change_to_price?
      create_price_history
      redirect_to item_path(@item), notice: 'Preço editado com sucesso!'

    else
      flash.now[:alert] = 'Falha ao editar preço.'
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def create_price_history
    ph_description = "#{@item.name} - #{@portion.description}"

    @item.restaurant.price_histories.create(description: ph_description, price: @portion.price,
                                            item_id: @item.id, portion_id: @portion.id, 
                                            insertion_date: Time.now.strftime('%d/%m/%Y'))
  end

  def set_item_and_validate_current_user
    @item = Item.find(params[:item_id])
    unless @item.restaurant == current_user.restaurant
      redirect_to items_path, alert: 'Você não pode acessar esse item'
    end
  end

  def set_portion
    @portion = Portion.find(params[:id])
  end

  def portion_params
    params.require(:portion).permit(:description, :price)
  end
end