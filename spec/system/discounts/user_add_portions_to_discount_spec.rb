require 'rails_helper'

describe 'Usuário adiciona porção ao desconto' do
  it 'e precisa estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.create!(restaurant: restaurant, name: 'Promoção', discount_amount: 20, 
                                starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)

    visit edit_discount_path discount

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.create!(restaurant: restaurant, name: 'Promoção', discount_amount: 20, 
                                starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', description: 'Croquete de carne')
    Portion.create!(description: '10 unid.', price: 58.90, item: dish)
    Portion.create!(description: '4 unid.', price: 30.90, item: dish)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca cola', description: 'Coca gelada')
    Portion.create(description: 'Coca Lata', price: 7.50, item: beverage)
    Portion.create(description: 'Coca 1,5L', price: 18.50, item: beverage)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Gerenciar descontos'
    end
    click_on 'Promoção'
    click_on 'Adicionar porções'
    check '10 unid.'
    check 'Coca 1,5L'
    click_on 'Enviar'

    expect(current_path).to eq discount_path discount
    expect(discount.discount_portions.count).to eq 2
    expect(page).to have_content 'Porções do desconto atualizadas com sucesso!'
    expect(page).to have_content 'Porções incluídas:'
    expect(page).to have_link 'Croquete'
    expect(page).to have_content '10 unid.'
    expect(page).to have_link 'Coca cola'
    expect(page).to have_content 'Coca 1,5L'
  end
end