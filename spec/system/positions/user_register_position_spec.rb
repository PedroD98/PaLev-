require 'rails_helper'

describe 'Usuário cadastra cargos' do
  it 'e precisa estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit new_restaurant_position_path restaurant

    expect(current_path).to eq new_user_session_path
  end

  it 'e forumlário existe' do
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
    click_on 'Registre um cargo'

    expect(current_path).to eq new_restaurant_position_path restaurant
    expect(page).to have_content 'Novo cargo:'
    expect(page).to have_field 'Descrição do cargo'
    expect(page).to have_button 'Criar cargo'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_restaurant_position_path restaurant
    fill_in 'Descrição do cargo', with: 'Gerente'
    click_on 'Criar cargo'

    expect(current_path).to eq restaurant_positions_path restaurant
    expect(page).to have_content 'Cargo criado com sucesso!'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content "#{Date.today.strftime('%d/%m/%Y')}"
  end

  it 'e tenta cadastrar cargo em outro restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    other_user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                              email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: other_user)

    login_as other_user
    visit new_restaurant_position_path restaurant

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode acessar essa página.'
    expect(page).not_to have_content 'Novo cargo:'
  end
end