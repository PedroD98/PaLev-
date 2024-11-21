require 'rails_helper'

describe 'Usuário envia pedido para a cozinha' do
  
  it 'e valores totais são armazenados corretamente' do
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
    OrderPortion.create!(order: order, portion: fries_portion, qty: 1, discount: fries_discount)
    OrderPortion.create!(order: order, portion: other_fries_portion, qty: 1, discount: fries_discount)
    OrderPortion.create!(order: order, portion: soda_portion, qty: 2, discount: soda_discount)
    
    login_as user
    visit order_path order
    click_on 'Enviar para cozinha'
    order.reload

    expect(order.total_amount).to eq 102.50
    expect(order.total_discount_amount).to eq 64.35
  end
end