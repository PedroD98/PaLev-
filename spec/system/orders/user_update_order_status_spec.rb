require 'rails_helper'

describe 'Usuário altera status do pedido' do

  it 'e botões aparecem na tela' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on "Pedido #{order.code}"

    expect(page).to have_button 'Enviar para cozinha'
    expect(page).to have_button 'Cancelar'
  end

  it 'para Aguardando confirmação da cozinha' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')

    login_as user
    visit order_path order
    click_on 'Enviar para cozinha'

    expect(page).to have_content 'Pedido enviado para a cozinha.'
    expect(page).to have_content 'Status: Aguardando confirmação da cozinha'
    expect(page).to have_button 'Iniciar preparo'
    expect(page).to have_button 'Cancelar'
    expect(page).not_to have_button 'Enviar para cozinha'
    expect(page).not_to have_button 'Pronto para entrega'
    expect(page).not_to have_button 'Entregue'
  end

  it 'para Em preparação' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com', status: :confirming)

    login_as user
    visit order_path order
    click_on 'Iniciar preparo'

    expect(page).to have_content 'Pedido foi confirmado e está sendo preparado.'
    expect(page).to have_content 'Status: Em preparação'
    expect(page).to have_button 'Pronto para entrega'
    expect(page).to have_button 'Cancelar'
    expect(page).not_to have_button 'Iniciar preparo'
    expect(page).not_to have_button 'Enviar para cozinha'
    expect(page).not_to have_button 'Entregue'
  end

  it 'para Pronto' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com', status: :preparing)

    login_as user
    visit order_path order
    click_on 'Pronto para entrega'

    expect(page).to have_content 'Pedido pronto para a entrega.'
    expect(page).to have_content 'Status: Pronto'
    expect(page).to have_button 'Entregue'
    expect(page).to have_button 'Cancelar'
    expect(page).not_to have_button 'Iniciar preparo'
    expect(page).not_to have_button 'Pronto para entrega'
    expect(page).not_to have_button 'Enviar para cozinha'
  end

  it 'para Entregue' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com', status: :done)

    login_as user
    visit order_path order
    click_on 'Entregue'

    expect(page).to have_content 'Pedido entregue com sucesso.'
    expect(page).to have_content 'Status: Entregue'
    expect(page).not_to have_button 'Entregue'
    expect(page).not_to have_button 'Cancelar'
    expect(page).not_to have_button 'Iniciar preparo'
    expect(page).not_to have_button 'Pronto para entrega'
    expect(page).not_to have_button 'Enviar para cozinha'
  end

  it 'para Cancelado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')

    login_as user
    visit order_path order
    click_on 'Cancelar'

    expect(page).to have_content 'Pedido cancelado.'
    expect(page).to have_content 'Status: Cancelado'
    expect(page).not_to have_button 'Entregue'
    expect(page).not_to have_button 'Cancelar'
    expect(page).not_to have_button 'Iniciar preparo'
    expect(page).not_to have_button 'Pronto para entrega'
    expect(page).not_to have_button 'Enviar para cozinha'
  end
end