require 'rails_helper'

describe 'Usuário adiciona itens ao cardápio' do
  it 'e formulário existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                 description: 'Caldo de feijão saboroso', calories: 274)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca cola',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Cardápios'
    click_on 'Jantar'
    click_on 'Adicionar item'

    expect(current_path).to eq edit_restaurant_menu_path(restaurant, menu)
    expect(page).to have_content 'Adicionar items ao cardápio: Jantar'
    expect(page).to have_content 'Prato:'
    expect(page).to have_content 'Bebida:'
    expect(page).to have_button 'Adicionar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango', calories: 450)
    Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                 description: 'Caldo de feijão saboroso', calories: 274)

    login_as user
    visit restaurant_menu_path(restaurant, menu)
    click_on 'Adicionar item'
    select 'Feijão amigo', from: 'menu[item_ids][]'
    click_on 'Adicionar'
    
    
    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
    expect(menu.items.count).to eq 1
    expect(page).to have_content 'Itens adicionados com sucesso!'
    expect(page).to have_content 'Pratos:'
    expect(page).to have_link 'Feijão amigo'
  end
end