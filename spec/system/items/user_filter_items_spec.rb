require 'rails_helper'

describe 'Usuário acessa lista de items' do
  it 'e vê filtro de marcadores' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Tag.create(restaurant: restaurant, name: 'Apimentado')
    Tag.create(restaurant: restaurant, name: 'Vegano')

    login_as user
    visit root_path
    click_on 'Menu do restaurante'

    expect(page).to have_content 'Filtrar por:'
    expect(page).to have_field 'Apimentado'
    expect(page).to have_field 'Vegano'
    expect(page).to have_button 'Aplicar'
  end

  it 'e utiliza um filtro' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    tag1 = Tag.create(restaurant: restaurant, name: 'Apimentado')
    tag2 = Tag.create(restaurant: restaurant, name: 'Vegano')
    tag3 = Tag.create(restaurant: restaurant, name: 'Sem glúten')
    Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                 description: 'Caldo de feijão saboroso', calories: 274, tags: [tag1, tag2])
    Dish.create!(restaurant_id: restaurant.id, name: 'Pão', 
                 description: 'Pão sem glúten', calories: 274, tags: [tag3])

    login_as user
    visit items_path
    check 'Apimentado'
    check 'Vegano'
    click_on 'Aplicar'

    expect(page).to have_content 'Pratos filtrados por: Apimentado, Vegano'
    expect(page).to have_link 'Feijão amigo'
    expect(page).not_to have_link 'Pão'
  end
end