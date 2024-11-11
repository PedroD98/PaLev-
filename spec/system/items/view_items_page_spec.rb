require 'rails_helper'

describe 'Usuário faz login' do
  it 'e acessa página dos itens' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Itens do restaurante:'
    expect(page).to have_content 'Seu restaurante ainda não possui nenhum item.'
    expect(page).to have_link 'Registre um prato'
    expect(page).to have_link 'Registre uma bebida'
  end

  it 'e precisa ser o dono do restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    employee = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                            email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    employee.restaurant = restaurant


    login_as employee
    visit items_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end
end