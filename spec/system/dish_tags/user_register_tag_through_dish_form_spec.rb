require 'rails_helper'

describe 'Usuário registra prato' do
  it 'e cria marcadores pelo campo Novo marcador' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Tag.create!(restaurant: restaurant, name: 'Gorduroso')


    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Registre um prato'
    fill_in 'Nome', with: 'Feijão mexicano'
    fill_in 'Descrição', with: 'Caldo de feijão saboroso'
    check 'Gorduroso'
    fill_in 'Novo marcador', with: 'Altamente picante'
    click_on 'Enviar'
    dish = restaurant.items.last

    expect(dish.tags.count).to eq 2
    expect(page).to have_content 'Gorduroso'
    expect(page).to have_content 'Altamente picante'
  end

  it 'e cria um marcador válido' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit new_dish_path
    fill_in 'Nome', with: 'Feijão mexicano'
    fill_in 'Descrição', with: 'Caldo de feijão saboroso'
    fill_in 'Novo marcador', with: 'P1c4nte#'
    click_on 'Enviar'
    dish = restaurant.items.last

    expect(current_path).not_to eq item_path(dish)
    expect(Tag.all.count).to eq 0
    expect(page).to have_content 'Falha ao registrar prato'
    expect(page).to have_content 'Novo marcador inválido'
  end
end