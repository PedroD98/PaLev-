require 'rails_helper'

describe 'Usuário acessa a página de detalhes de um desconto' do
  it 'e precisa estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.create!(restaurant: restaurant, name: 'Desconto da batata', discount_amount: 20, 
                                starting_date: Date.today, ending_date: Date.tomorrow)

    visit discount_path discount

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.create!(restaurant: restaurant, name: 'Dia da Pizza', discount_amount: 20, 
                                starting_date: Date.today, ending_date: Date.tomorrow, max_use: 100)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Gerenciar descontos'
    end
    click_on 'Dia da Pizza'

    expect(current_path).to eq discount_path discount
    expect(page).to have_content 'Desconto: Dia da Pizza'
    expect(page).to have_content 'Porcentagem do desconto: 20%'
    expect(page).to have_content "Início: #{Date.today.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Encerramento: #{Date.tomorrow.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Limite de uso: 100'
    expect(page).to have_content 'Usos restantes: 100'
    expect(page).to have_link 'Voltar'
  end

  it 'e vê pedidos que usaram o desconto' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                         email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), restaurant: restaurant)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Batata frita', description: 'Batata sequinha')
    fries_portion = Portion.create!(description: 'Família', price: 50, item: dish)
    other_fries_portion = Portion.create!(description: 'Individual', price: 15.50, item: dish)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca cola', description: 'Coca gelada')
    soda_portion = Portion.create(description: 'Coca 1,5L', price: 18.50, item: beverage)
    fries_discount = Discount.create!(restaurant: restaurant, name: 'Promoção da batata', discount_amount: 30, 
                                      starting_date: Date.today, ending_date: Date.tomorrow)
    soda_discount = Discount.create!(restaurant: restaurant, name: 'Promoção do refri', discount_amount: 50, 
                                     starting_date: Date.today, ending_date: Date.tomorrow)
    order = Order.create!(restaurant: restaurant, customer_name: 'João', customer_email: 'joão@gmail.com')
    other_order = Order.create!(restaurant: restaurant, customer_name: 'Pedro', customer_email: 'pedro@gmail.com')
    OrderPortion.create!(order: order, portion: fries_portion, qty: 1, discount: fries_discount)
    OrderPortion.create!(order: order, portion: other_fries_portion, qty: 1, discount: fries_discount)
    OrderPortion.create!(order: order, portion: soda_portion, qty: 2, discount: soda_discount)
    DiscountOrder.create!(discount: soda_discount, order: other_order)
    
    login_as user
    visit order_path order
    click_on 'Enviar para cozinha'
    visit discount_path fries_discount

    expect(page).to have_content 'Desconto: Promoção da batata'
    expect(page).not_to have_content 'Desconto: Promoção do refri'
    expect(page).to have_link order.code
    expect(page).to have_content order.created_at.strftime('%d/%m/%Y')
    expect(page).to have_content "R$ 102,50"
    expect(page).to have_content "R$ 64,35"
    expect(page).not_to have_link other_order.code
  end
end