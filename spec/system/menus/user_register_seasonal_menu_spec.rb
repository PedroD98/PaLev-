require 'rails_helper'

describe 'usuário cria cardápio sazonal' do
  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_restaurant_menu_path restaurant
    fill_in 'Nome', with: 'Café de inverno'
    fill_in 'Data de início', with: Date.today
    fill_in 'Data de encerramento', with: Date.tomorrow
    click_on 'Enviar'
    menu = restaurant.menus.last

    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
    expect(page).to have_content 'Cardápio cadastrado com sucesso!'
    expect(page).to have_content 'Cardápio: Café de inverno'
    expect(page).to have_content "Data de início: #{Date.today.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data de encerramento: #{Date.tomorrow.strftime('%d/%m/%Y')}"
  end
  
  it 'e precisa preencher as duas datas' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_restaurant_menu_path restaurant
    fill_in 'Nome', with: 'Café de inverno'
    fill_in 'Data de início', with: Date.today
    fill_in 'Data de encerramento', with: ''
    click_on 'Enviar'

    expect(restaurant.menus.count).to eq 0
    expect(page).to have_content 'Falha ao cadastrar cardápio.'
    expect(page).to have_content 'Para cardápios sazonais, ambas as datas devem ser preenchidas.'
    expect(page).to have_field 'Nome', with: 'Café de inverno'
  end

  it 'caso exista um pedido em criação, menu só é exibido durante o período válido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Order.create!(restaurant: restaurant, customer_name: 'João', customer_email: 'joao@gmail.com')
    Menu.create!(restaurant: restaurant, name: 'Executivo')

    travel 1.day do
      Menu.create!(restaurant: restaurant, name: 'Café de inverno',
                  starting_date: Date.today, ending_date: Date.tomorrow)
    end

    login_as user
    visit restaurant_menus_path restaurant

    expect(page).to have_content 'Cardápios:'
    expect(page).to have_content 'Regulares:'
    expect(page).to have_link 'Executivo'
    expect(page).not_to have_content 'Sazonais:'
    expect(page).not_to have_link 'Café de inverno'
  end
end