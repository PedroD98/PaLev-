require 'rails_helper'

describe 'Usuário acessa detalhes de um pedido' do
  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                          customer_email: 'ana@gmail.com', customer_phone: '21222704555', status: :confirming)

    visit restaurant_order_path(restaurant, order) 

    expect(current_path).to eq new_user_session_path
  end

  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                          customer_email: 'ana@gmail.com', customer_phone: '21222704555')

    login_as user 
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on "Pedido #{order.code}"

    expect(current_path).to eq restaurant_order_path(restaurant, order)
    expect(page).to have_content 'O pedido está vazio.'
    expect(page).to have_link 'Clique aqui'
    expect(page).to have_content "Detalhes do Pedido: #{order.code}"
    expect(page).to have_content "Status: #{I18n.t(order.status)}"
    expect(page).to have_content 'Informações do cliente:'
    expect(page).to have_content 'Nome: Ana'
    expect(page).to have_content 'CPF: 756.382.144-96'
    expect(page).to have_content 'E-mail: ana@gmail.com'
    expect(page).to have_content 'Telefone de contato: 21222704555'
    
  end

  it 'e vai para a página de cardápios a partir dos detalhes do pedido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                          customer_email: 'ana@gmail.com', customer_phone: '21222704555')
    Menu.create!(restaurant: restaurant, name: 'Executivo')

    login_as user 
    visit restaurant_order_path(restaurant, order)
    click_on 'Clique aqui'

    expect(current_path).to eq restaurant_menus_path restaurant
  end
end