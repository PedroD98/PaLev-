require 'rails_helper'

describe 'Funcionário faz login' do
  it 'e vê menu limitado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    employee = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                            email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    employee.restaurant = restaurant

    login_as employee
    visit root_path

    expect(page).to have_link 'Meu restaurante'
    expect(page).to have_link 'Meu perfil'
    expect(page).to have_link 'Cardápios'
    expect(page).to have_link 'Pedidos'
    expect(page).not_to have_link 'Lista de itens'
    expect(page).not_to have_link 'Cargos'
    expect(page).not_to have_link 'Gerenciar marcadores'
    expect(page).not_to have_link 'Pré-cadastros'
    expect(page).not_to have_content 'Buscar no menu'
  end
end