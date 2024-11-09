require 'rails_helper'

describe 'Usuário tenta acessar outro restaurante' do
  it 'e criar um pré-cadastro' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)
    position = Position.create!(restaurant: restaurant, description: 'Cozinheiro')

    login_as other_user
    post(pre_registers_path, params: { pre_register: {restaurant: restaurant, user: user, position_id: position.id, 
                             employee_social_number: '133.976.443-13', employee_email: 'ana@gmail.com'} })

    expect(response).to redirect_to root_path
    follow_redirect!
    expect(response.body).to include 'Apenas o dono do restaurante pode criar pré-cadastros.'
  end
end