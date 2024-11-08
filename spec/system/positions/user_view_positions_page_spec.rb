require 'rails_helper'

describe 'Usuário acessa página de cargos' do
  it 'e precisa estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit restaurant_positions_path restaurant

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Cargos'
    end

    expect(current_path).to eq restaurant_positions_path restaurant
    expect(page).to have_content 'Cargos cadastrados:'
    expect(page).to have_link 'Registre um cargo'
  end

  it 'e cargos cadastrados são listados' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Position.create!(restaurant: restaurant, description: 'Gerente')
    Position.create!(restaurant: restaurant, description: 'Cozinheiro')

    login_as user
    visit restaurant_positions_path restaurant

    expect(page).not_to have_link 'Registre um cargo'
    expect(page).to have_content 'Cargos cadastrados:'
    expect(page).to have_link 'Novo cargo'
    expect(page).to have_content 'Cargo'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Cozinheiro'
    expect(page).to have_content 'Data de cadastro'
    expect(page).to have_content "#{Date.today.strftime('%d/%m/%Y')}"
  end
end