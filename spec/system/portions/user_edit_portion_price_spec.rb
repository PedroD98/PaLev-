require 'rails_helper'

describe 'Usuário edita o preço de uma porção' do
  it 'a partir do menu' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)
    portion = Portion.create!(description: '10 unid.', price: 58.90, item: dish)

    login_as user
    visit items_path
    click_on 'Croquete'
    click_on 'Editar preço'

    expect(current_path).to eq edit_item_portion_path(dish, portion)
    expect(page).to have_content 'Editar preço de Croquete: 10 unid.'
    expect(page).not_to have_field 'Descrição'
    expect(page).to have_field 'Preço', with: 58.90
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)
    Portion.create!(description: '10 unid.', price: 58.90, item: dish)

    login_as user
    visit items_path
    click_on 'Croquete'
    click_on 'Editar preço'
    fill_in 'Preço', with: 45.50
    click_on 'Enviar'

    expect(current_path).to eq item_path(dish)
    expect(page).not_to have_content 'Editar preço de Croquete: 10 unid.'
    expect(page).to have_content 'Preço editado com sucesso!'
    expect(page).to have_content '10 unid.'
    expect(page).to have_content 'R$ 45,50'
    expect(page).to have_link 'Editar preço'
  end

  it 'e não deixa o preço em branco' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)
    Portion.create!(description: '10 unid.', price: 58.90, item: dish)

    login_as user
    visit items_path
    click_on 'Croquete'
    click_on 'Editar preço'
    fill_in 'Preço', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao editar preço.'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).not_to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end
end