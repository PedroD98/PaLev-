class Users::RegistrationsController < Devise::RegistrationsController
  def create
    email = sign_up_params[:email]
    social_number  = sign_up_params[:social_number]
    
    pre_register = PreRegister.find_by(employee_email: email, 
                                         employee_social_number: social_number)

    pre_registered_social_number = PreRegister.find_by(employee_social_number: social_number)
    pre_registered_email = PreRegister.find_by(employee_email: email)
      
      
    if pre_register
      self.resource = Employee.new(sign_up_params)
      resource.is_owner = false
      resource.registered_restaurant = true
      resource.position = pre_register.position
      resource.restaurant = pre_register.restaurant

      if resource.save
        pre_register.update(active: true)
        sign_up(resource_name, resource)
        redirect_to root_path, notice: 'Conta criada com sucesso!'
      else
        clean_up_passwords resource
        render 'new', status: :unprocessable_entity
      end
    
    elsif pre_registered_social_number
      flash.now[:alert] = 'Esse CPF faz parte de um  pré-cadastro. Verifique se o e-mail foi digitado corretamente'
      self.resource = User.new(sign_up_params)
      render 'new', status: :unprocessable_entity

    elsif pre_registered_email
      flash.now[:alert] = 'Esse e-mail faz parte de um  pré-cadastro. Verifique se o CPF foi digitado corretamente'
      self.resource = User.new(sign_up_params)
      render 'new', status: :unprocessable_entity
    
    else
      super

    end
  end
end
