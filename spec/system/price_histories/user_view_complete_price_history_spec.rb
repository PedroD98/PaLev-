require 'rails_helper'

describe 'Usuário acessa histórico de preços' do
  it 'a partir do restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update!(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                       description: 'Coxinha de frango')
    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Pepsi',
                                description: 'Pepsi gelada')
    portion = Portion.create!(description: '10 unid.', price: 68.50, item: dish)
    other_portion = Portion.create!(description: 'Pepsi lata', price: 7.50, item: beverage)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: "#{dish.name} - #{portion.description}")
    PriceHistory.create!(restaurant: restaurant, item_id: beverage.id, portion_id: other_portion.id,
                         price: other_portion.price, insertion_date: I18n.l(Date.today),
                         description: "#{beverage.name} - #{other_portion.description}")

    login_as user
    visit root_path
    click_on 'Meu restaurante'
    click_on 'Histórico de preços completo'

    expect(page).to have_content 'Histórico de preços do restaurante:'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Data de entrada'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'Coxinha - 10 unid.'
    expect(page).to have_content 'R$ 68,50'
    expect(page).to have_content I18n.l(Date.today)
    expect(page).to have_content 'Pepsi - Pepsi lata'
    expect(page).to have_content 'R$ 7,50'
    expect(page).to have_link 'Tabela do item'
    expect(page).to have_link 'Tabela da porção'
    expect(page).to have_link 'Voltar para restaurante'
    expect(page).to have_link 'Lista de itens'
  end

  it 'a partir do item' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne')
    portion = Portion.create!(description: '10 unid.', price: 58.90, item: dish)
    other_portion = Portion.create!(description: '5 unid.', price: 36.50, item: dish)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: 'Croquete - 10 unid.')
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: other_portion.id,
                         price: other_portion.price, insertion_date: I18n.l(Date.today),
                         description: 'Croquete - 5 unid.')

    login_as user
    visit item_path dish
    click_on 'Histórico de preços do item'

    
    expect(page).to have_content 'Histórico de preços do item: Croquete'
    expect(page).to have_content 'Croquete - 10 unid.'
    expect(page).to have_content 'Croquete - 5 unid.'
    expect(page).to have_content I18n.l(Date.today)
    expect(page).to have_content 'R$ 58,90'
    expect(page).to have_content 'R$ 36,50'
    expect(page).to have_link 'Tabela da porção'
    expect(page).to have_link 'Voltar para Croquete'
    expect(page).to have_link 'Lista de itens'
    expect(page).to have_link 'Histórico completo do restaurante'
    expect(page).not_to have_link 'Tabela do item'
  end

  it 'a partir da porção' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne')
    portion = Portion.create!(description: '10 unid.', price: 58.90, item: dish)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: 'Croquete - 10 unid.')
    portion.update(price: 79.99)
    PriceHistory.create!(restaurant: restaurant, item_id: dish.id, portion_id: portion.id,
                         price: portion.price, insertion_date: I18n.l(Date.today),
                         description: 'Croquete - 10 unid.')

    login_as user
    visit item_path dish
    click_on 'Histórico de preços'

    
    expect(page).to have_content 'Histórico de preços da porção: Croquete - 10 unid.'
    expect(page).to have_content 'Croquete - 10 unid.'
    expect(page).to have_content I18n.l(Date.today)
    expect(page).to have_content 'R$ 58,90'
    expect(page).to have_content 'R$ 79,99'
    expect(page).to have_link 'Tabela do item'
    expect(page).to have_link 'Voltar para Croquete'
    expect(page).to have_link 'Lista de itens'
    expect(page).to have_link 'Histórico completo do restaurante'
    expect(page).not_to have_link 'Tabela da porção'
  end
end