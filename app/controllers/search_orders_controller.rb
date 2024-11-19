class SearchOrdersController < ApplicationController
  def index
    
  end

  def search
    search_input = params[:query]
    order = Order.find_by(code: search_input)
    if order.nil?
      flash.now[:alert] = 'Pedido não encontrado.'
      render 'index', status: :unprocessable_entity

    else
      @searched_order = order
      flash.now[:notice] = 'Pedido encontrado!'
    end
  end
end