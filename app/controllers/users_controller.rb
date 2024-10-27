class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_has_registered_restaurant?
  before_action :validate_current_user, only: [:show]

  def show
    @user = current_user
  end

  private

  def validate_current_user
    user = User.find(params[:id])
    unless current_user == user
      redirect_to user_path(current_user), alert: 'Você não pode acessar esse perfil'
    end
  end

end