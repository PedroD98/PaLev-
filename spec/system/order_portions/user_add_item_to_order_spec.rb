require 'rails_helper'

describe 'Usuário adiciona um item ao pedido' do
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
    OrderPortion.create!(order: order, portion: portion, qty: 2)
    order.update(status: :confirming)

    login_as user
    visit new_restaurant_order_order_portion_path(restaurant, order, portion_id: portion.id)

    expect(current_path).to eq restaurant_order_path(restaurant, order)
    expect(page).to have_content 'Essa ação não está disponível para pedidos que não estão em fase de criação.'
  end
  
  it 'a partir da página de detalhes do pedido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    Portion.create!(item: dish, description: 'Individual', price: 29.90)
    menu = Menu.create!(restaurant: restaurant, name: 'Executivo', item_ids: [dish.id])

    login_as user 
    visit root_path
    within 'nav' do
      click_on 'Pedidos'
    end
    click_on "Pedido #{order.code}"
    click_on 'Clique aqui'
    click_on 'Executivo'

    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
    expect(page).to have_content 'Feijão amigo'
    expect(page).to have_content 'Individual - R$ 29,90'
    expect(page).to have_link 'Ir para o pedido'
    expect(page).to have_link 'Adicionar ao pedido'
  end

  it 'e formulário para registro de porção ao pedido existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    menu = Menu.create!(restaurant: restaurant, name: 'Executivo', item_ids: [dish.id])

    login_as user 
    visit restaurant_menu_path(restaurant, menu)
    click_on 'Adicionar ao pedido'

    expect(current_path).to eq new_restaurant_order_order_portion_path(restaurant, order)
    expect(page).to have_content "Adicionando item ao Pedido #{order.code}"
    expect(page).to have_content "#{portion.item.name} - #{portion.description}"
    expect(page).to have_field 'Quantidade'
    expect(page).to have_field 'Observações'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    Portion.create!(item: dish, description: 'Individual', price: 29.90)
    menu = Menu.create!(restaurant: restaurant, name: 'Executivo', item_ids: [dish.id])

    login_as user 
    visit restaurant_menu_path(restaurant, menu)
    click_on 'Adicionar ao pedido'
    fill_in 'Quantidade', with: '2'
    fill_in 'Observações', with: 'Sem cebola'
    click_on 'Enviar'

    expect(page).not_to have_content "Adicionando item ao Pedido #{order.code}"
    expect(current_path).to eq restaurant_order_path(restaurant, order)
    expect(page).to have_content 'Feijão amigo'
    expect(page).to have_content '2 x Individual - R$ 59,80'
    expect(page).to have_content 'Total do pedido: R$ 59,80'
  end

  it 'e não preenche a quantidade' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    Portion.create!(item: dish, description: 'Individual', price: 29.90)
    menu = Menu.create!(restaurant: restaurant, name: 'Executivo', item_ids: [dish.id])

    login_as user 
    visit restaurant_menu_path(restaurant, menu)
    click_on 'Adicionar ao pedido'
    fill_in 'Quantidade', with: ''
    fill_in 'Observações', with: 'Sem cebola'
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao adicionar item.'
    expect(page).to have_content 'Quantidade não pode ficar em branco'
    expect(page).to have_field 'Observações', with: 'Sem cebola'
  end

  it 'e total do pedido é calculado corretamente' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Coca cola', 
                                description: 'Coca gelada e refrescante')
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: beverage, description: 'Coca lata', price: 7.50)
    other_portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_phone: '21222704555')
    OrderPortion.create!(order: order, portion: portion, qty: 2)
    OrderPortion.create!(order: order, portion: other_portion, qty: 1)

    login_as user 
    visit restaurant_order_path(restaurant, order)

    expect(page).to have_content "Detalhes do Pedido: #{order.code}"
    expect(page).to have_content '1 x Individual - R$ 29,90'
    expect(page).to have_content '2 x Coca lata - R$ 15,00'
    expect(page).to have_content 'Total do pedido: R$ 44,90'
  end
end