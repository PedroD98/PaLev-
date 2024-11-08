require 'rails_helper'

describe 'Usuário acessa página de pedidos' do
  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit orders_path

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end

    expect(current_path).to eq orders_path
    expect(page).to have_content 'Pedidos:'
    expect(page).to have_content 'Seu restaurante não possui nenhum pedido registrado.'
    expect(page).to have_content 'Novo pedido'
  end

  it 'e pedidos são listados' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com', status: :confirming)
    other_order = Order.create!(restaurant: restaurant, customer_email: 'maria@gmail.com')

    login_as user
    visit orders_path

    expect(page).to have_link "Pedido #{order.code}"
    expect(page).to have_content "Status: Aguardando confirmação da cozinha"
    expect(page).to have_content "Realizado em: #{Date.today.strftime('%d/%m/%Y')}"
    expect(page).to have_link "Pedido #{other_order.code}"
    expect(page).to have_content "Status: Em criação"
  end
end