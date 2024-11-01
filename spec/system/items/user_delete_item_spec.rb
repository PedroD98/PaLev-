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
    click_on 'Excluir'

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
    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                                description: 'Coquinha gelada', calories: 139)

    login_as user
    visit item_path beverage
    click_on 'Excluir'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Bebida removida com sucesso!'
    expect(page).not_to have_content 'Coca lata'
  end

  it 'um item com porções e histórico de preço' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update!(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                       description: 'Coxinha de frango', calories: 274)
    portion = Portion.create!(description: '10 unid.', price: 68.50, item: dish)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: "#{dish.name} - #{portion.description}")

    login_as user
    visit item_path dish
    click_on 'Excluir'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Prato removido com sucesso!'
    expect(page).not_to have_content 'Coxinha'
  end
end