require 'rails_helper'

describe 'Usuário registra um pedido' do
  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit new_order_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e formulário existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), restaurant: restaurant)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on 'Novo pedido'

    expect(current_path).to eq new_order_path 
    expect(page).to have_content 'Novo Pedido:'
    expect(page).to have_content 'Detalhes do cliente:'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Telefone'
    expect(page).to have_button 'Enviar'
    expect(page).to have_link 'Cancelar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), restaurant: restaurant)

    login_as user
    visit new_order_path
    fill_in 'Nome', with: 'Ana Maria'
    fill_in 'CPF', with: '756.382.144-96'
    fill_in 'E-mail', with: 'ana@gmail.com'
    fill_in 'Telefone de contato', with: '21222704555'
    click_on 'Enviar'
    order = restaurant.orders.last

    expect(current_path).to eq order_path order
    expect(I18n.t order.status).to eq 'Em criação'
    expect(page).to have_content "Detalhes do Pedido: #{order.code}"
  end

  it 'e só pode existir um pedido em criação' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Order.create!(restaurant: restaurant, customer_email: 'maria@gmail.com')
    OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), restaurant: restaurant)

    login_as user
    visit new_order_path

    expect(current_path).to eq orders_path
    expect(page).to have_content 'É permitido ter apenas um pedido com status: Em criação.'
  end

  it 'e restaurante deve estar aberto' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    OperatingHour.create!(day_of_week: Date.current.wday, closed: true, restaurant: restaurant)

    login_as user
    visit new_order_path

    expect(current_path).to eq orders_path
    expect(page).to have_content 'O restaurante está fechado no momento.'
  end

  it 'e mensagem aparece corretamente se o restaurante estiver fechado.' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    OperatingHour.create!(day_of_week: Date.current.wday, closed: true, restaurant: restaurant)

    login_as user
    visit orders_path

    expect(current_path).to eq orders_path
    expect(page).to have_content 'Não é possível criar um pedido agora, pois o restaurante está fechado.'
    expect(page).not_to have_link 'Novo pedido'
  end
end