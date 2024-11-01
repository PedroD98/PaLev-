require 'rails_helper'

describe 'Usuário cria uma porção' do
  it 'e histórico de preço é criado automaticamente' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)

    login_as user
    visit root_path
    click_on 'Menu do restaurante'
    click_on 'Croquete'
    click_on 'Adicionar porção'
    fill_in 'Descrição', with: '10 unid.'
    fill_in 'Preço', with: 58.90
    click_on 'Enviar'
    portion = dish.portions.last

    expect(portion.price_histories.count).to eq 1
    expect(portion.price_histories.last.price).to eq 58.90
    expect(page).to have_link 'Histórico de preços'
  end

  it 'e histórico de preços é atualizado' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)
    portion = Portion.create!(description: '10 unid.', price: 58.90, item: dish)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: "#{dish.name} - #{portion.description}")

    login_as user
    visit item_path dish
    click_on 'Editar preço'
    fill_in 'Preço', with: 65.98
    click_on 'Enviar'
    click_on 'Histórico de preços'

    
    expect(page).to have_content I18n.l(Date.today)
    expect(page).to have_content 'R$ 58,90'
    expect(page).to have_content 'R$ 65,98'
  end
end