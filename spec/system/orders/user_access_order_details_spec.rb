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

    visit order_path order 

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
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

    expect(current_path).to eq order_path order
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
    visit order_path order
    click_on 'Clique aqui'

    expect(current_path).to eq restaurant_menus_path restaurant
  end

  it 'e tenta acessar detalhes de um pedido de outro usuário' do
    other_user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: other_user)
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')

    login_as other_user
    visit order_path order

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode acessar essa página.'
  end
end