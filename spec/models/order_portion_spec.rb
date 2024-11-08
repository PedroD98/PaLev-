require 'rails_helper'

describe 'valid#' do
  it 'falso quando quantidade estiver em branco' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Feijão amigo', 
                        description: 'Caldo de feijão saboroso')
    portion = Portion.create!(item: dish, description: 'Individual', price: 29.90)
    order = Order.create!(restaurant: restaurant, customer_email: 'ana@gmail.com')
    order_portion = OrderPortion.new(order: order, portion: portion, qty: '')

    expect(order_portion).not_to be_valid
    expect(order_portion.errors.include? :qty).to be true
  end
end