require 'rails_helper'

describe 'Usuário registra cardápio' do
  it 'e formulário existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit restaurant_path restaurant
    click_on 'Cardápios'
    click_on 'Novo cardápio'

    expect(current_path).to eq new_restaurant_menu_path restaurant
    expect(page).to have_content 'Novo cardápio'
    expect(page).to have_field 'Nome'
    expect(page).to have_button 'Enviar'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_restaurant_menu_path restaurant
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(restaurant.menus.count).to eq 0
    expect(page).to have_content 'Falha ao cadastrar cardápio.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_field 'Nome'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_restaurant_menu_path restaurant
    fill_in 'Nome', with: 'Café da manhã'
    click_on 'Enviar'
    menu = restaurant.menus.last

    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
    expect(page).to have_content 'Cardápio cadastrado com sucesso!'
    expect(page).to have_content 'Detalhes do cardápio: Café da manhã'
    expect(page).to have_link 'Lista de cardápios'
  end
end