class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found

  private

  def return_not_found
    render status: 404
  end

  def return_internal_server_error
    render status: 500, json: { error: 'Erro de servidor interno' }
  end
end