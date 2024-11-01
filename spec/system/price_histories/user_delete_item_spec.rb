require 'rails_helper'

describe 'Usuário exclui um item' do
  it 'e histórico persiste no banco de dados' do
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
    click_on 'Meu restaurante'
    click_on 'Histórico de preços completo'

    expect(page).to have_content 'Coxinha - 10 unid.'
    expect(page).to have_content 'R$ 68,50'
    expect(page).to have_content I18n.l(Date.today)
    expect(page).not_to have_link 'Tabela do item'
  end
end