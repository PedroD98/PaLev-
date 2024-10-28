require 'rails_helper'

describe 'Usuário edita o status do item' do
  it 'e desativa o item' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Brownie', 
                        description: 'Brownie fofo')

    login_as user
    visit root_path
    click_on 'Menu do restaurante'
    click_on 'Brownie'
    click_on 'Desativar item'

    expect(current_path).to eq dish_path dish
    expect(page).to have_content 'Status: Desativado'
    expect(page).to have_content 'O item foi desativado.'
    expect(page).to have_button 'Ativar item'
    expect(page).not_to have_button 'Desativar item'
  end

  it 'e ativa o item' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Laramora', 
                        description: 'Suco de laranja com morango', status: :deactivated)

    login_as user
    visit root_path
    click_on 'Menu do restaurante'
    click_on 'Laramora'
    click_on 'Ativar item'

    expect(current_path).to eq beverage_path beverage
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'O item foi ativado.'
    expect(page).to have_button 'Desativar item'
    expect(page).not_to have_button 'Ativar item'
  end
end