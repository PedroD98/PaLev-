require 'rails_helper'

describe 'Usuário acessa seus cardápios' do
  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit restaurant_menus_path restaurant

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit restaurant_path restaurant
    within 'nav' do
      click_on 'Cardápios'
    end

    expect(current_path).to eq restaurant_menus_path restaurant
    expect(page).to have_content 'Nenhum cardápio registrado.'
    expect(page).to have_link 'Novo cardápio'
  end

  it 'e cardápios são listados' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Menu.create!(restaurant: restaurant, name: 'Executivo')
    Menu.create!(restaurant: restaurant, name: 'Café da manhã')

    login_as user
    visit restaurant_menus_path restaurant

    expect(page).to have_content 'Cardápios:'
    expect(page).to have_link 'Executivo'
    expect(page).to have_link 'Café da manhã'
    expect(page).to have_link 'Novo cardápio'
  end
end