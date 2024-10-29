require 'rails_helper'

describe 'Usuário exclui' do
  it 'um prato com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update!(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango', calories: 274)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coxinha'
    click_on 'Excluir item'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Prato removido com sucesso!'
    expect(page).not_to have_content 'Coxinha'
  end

  it 'uma bebida com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update!(registered_restaurant: true)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coca lata'
    click_on 'Excluir item'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Bebida removida com sucesso!'
    expect(page).not_to have_content 'Coca lata'
  end
end