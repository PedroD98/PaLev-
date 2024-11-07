require 'rails_helper'

describe 'Usuário acessa página de pedidos' do
  it 'e formulário existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on 'Novo pedido'

    expect(current_path).to eq new_restaurant_order_path restaurant
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

    login_as user
    visit new_restaurant_order_path restaurant
    fill_in 'Nome', with: 'Ana Maria'
    fill_in 'CPF', with: '756.382.144-96'
    fill_in 'E-mail', with: 'ana@gmail.com'
    fill_in 'Telefone de contato', with: '21222704555'
    click_on 'Enviar'
    order = restaurant.orders.last

    expect(current_path).to eq restaurant_order_path(restaurant, order)
    expect(I18n.t order.status).to eq 'Em criação'
    expect(page).to have_content "Detalhes do Pedido: #{order.code}"
  end
end