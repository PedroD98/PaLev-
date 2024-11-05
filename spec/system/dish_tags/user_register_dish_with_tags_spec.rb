require 'rails_helper'

describe 'Usuário registra prato' do
  it 'e prato possui marcadores' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    tag = Tag.create!(restaurant: restaurant, name: 'Vegano')
    Tag.create!(restaurant: restaurant, name: 'Sem glúten')


    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'
    click_on 'Registre um prato'
    fill_in 'Nome', with: 'Feijão mexicano'
    fill_in 'Descrição', with: 'Caldo de feijão saboroso'
    check 'Vegano'
    click_on 'Enviar'
    dish = restaurant.items.last

    expect(current_path).to eq item_path(dish)
    expect(dish.tags.last).to eq tag
    expect(dish.tags.count).to eq 1
  end

  it 'e marcadores aparecem na tela de detalhes do prato' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    tag = Tag.create!(restaurant: restaurant, name: 'Vegano')
    Tag.create!(restaurant: restaurant, name: 'Sem glúten')
    Dish.create!(name: 'Feijão amigo', description: 'Caldo saboroso',
                 restaurant: restaurant, tags: [tag])

    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'
    click_on 'Feijão amigo'

    expect(page).to have_content 'Características:'
    expect(page).to have_content 'Vegano'
    expect(page).not_to have_content 'Sem glúten'
  end
end