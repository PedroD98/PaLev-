class OperatingHoursController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :user_is_employee?, only: [:new, :create]
  before_action :set_restaurant
  before_action :validate_current_user, only: [:show]

  def new
    if @restaurant.operating_hours.any?
      redirect_to restaurant_operating_hour_path(@restaurant, @restaurant.operating_hours.first.id), 
      alert: 'Seu Horário de funcionamento já foi cadastrado'
    end
    @operating_hours = Array.new(7) { OperatingHour.new }
  end

  def create
    @operating_hours = operating_hours_params.map do |day_params|
      OperatingHour.new(day_params.merge(restaurant_id: @restaurant.id))
    end

    if @operating_hours.all?(&:valid?)
      @operating_hours.each { |day_hours| @restaurant.operating_hours << day_hours }
      redirect_to restaurant_operating_hour_path(@restaurant, @operating_hours.first.id), notice: 'Horário de funcionamento registrado com sucesso'
    else
      flash.now[:alert] = 'Falha ao registrar horários. Preencha todos os campos.'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def validate_current_user
    if @restaurant.id != params[:restaurant_id].to_i
      redirect_to current_user.restaurant, alert: 'Você não tem acesso à esse restaurante.'
    end
  end

  def operating_hours_params
    params.require(:operating_hours).values.map do |param|
      param.permit(:day_of_week, :open_time, :close_time, :closed, :restaurant_id)
    end
  end
end
