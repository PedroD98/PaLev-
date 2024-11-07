require 'rails_helper'

describe 'Usuário edita item do pedido' do
  it 'e item deve estar em fase de criação' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.create!(order: order, portion: portion, qty: 2)
    order.update(status: :confirming)

    login_as user
    visit edit_order_order_portion_path(order, order_portion, portion_id: portion.id)

    expect(current_path).to eq order_path order
    expect(page).to have_content 'Essa ação não está disponível para pedidos que não estão em fase de criação.'
  end
  
  it 'e página de edição existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.create!(order: order, portion: portion, qty: 2)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on "Pedido #{order.code}"
    click_on 'Editar'

    expect(current_path).to eq edit_order_order_portion_path(order, order_portion)
    expect(page).to have_content "Editando item do Pedido #{order.code}"
    expect(page).to have_field 'Quantidade', with: '2'
    expect(page).to have_field 'Observações'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.create!(order: order, portion: portion, qty: 2)

    login_as user
    visit edit_order_order_portion_path(order, order_portion, portion_id: portion.id)
    fill_in 'Quantidade', with: '3'
    fill_in 'Observações', with: 'Não muito quente, por favor.'
    click_on 'Enviar'

    expect(current_path).to eq order_path order
    expect(page).to have_content 'Item do pedido atualizado com sucesso!'
    expect(page).to have_content 'Feijão amigo'
    expect(page).to have_content '3 x Individual - R$ 89,70'
    expect(page).to have_content 'Total do pedido: R$ 89,70'
    expect(page).to have_link 'Editar'
  end

  it 'e não preenche a quantidade' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.create!(order: order, portion: portion, qty: 2)

    login_as user
    visit edit_order_order_portion_path(order, order_portion, portion_id: portion.id)
    fill_in 'Quantidade', with: ''
    fill_in 'Observações', with: 'Não muito quente, por favor.'
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao atualizar item do pedido.'
    expect(page).to have_content 'Quantidade não pode ficar em branco'
    expect(page).to have_field 'Observações', with: 'Não muito quente, por favor.'
  end

  it 'e tenta editar item a um pedido de outro usuário' do
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
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.create!(order: order, portion: portion, qty: 2)

    login_as other_user
    visit edit_order_order_portion_path(order, order_portion, portion_id: portion.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode acessar essa página.'
  end
end