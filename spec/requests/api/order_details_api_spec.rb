require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/restaurants/:restaurant_code/orders/:order_code' do
    it 'erro se o código do pedido for inválido' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

      get "/api/v1/restaurants/#{restaurant.code}/orders/ABCD123"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response['error']).to eq 'Pedido não encontrado'
    end

    it 'e mostra detalhes do pedido com sucesso' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_email: 'pedro@outlook.com',
                            customer_name: 'Pedro', status: :confirming)
      dish = Dish.create!(restaurant_id: restaurant.id, name: 'Sorvete de chocolate', 
                          description: 'Sorvete belga')
      beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Coca cola',
                                  description: 'Refrigerante alto em açúcar')
      dish_portion_1 = Portion.create!(item: dish, description: '1 bola', price: 6.90)
      dish_portion_2 = Portion.create!(item: dish, description: '3 bolas', price: 15.70)
      beverage_portion = Portion.create!(item: beverage, description: 'Lata', price: 7)
      OrderPortion.create!(order: order, portion: dish_portion_1, qty: 1,
                                           description: 'Calda de café')
      OrderPortion.create!(order: order, portion: dish_portion_2, qty: 2)
      OrderPortion.create!(order: order, portion: beverage_portion, qty: 1,
                           description: 'Extremamente gelada')

      get "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['order']['customer_name']).to eq 'Pedro'
      expect(json_response['order']['created_at']).to eq Date.today.strftime('%d/%m/%Y')
      expect(json_response['order']['status']).to eq 'Aguardando confirmação da cozinha'
      expect(json_response['items'][0]['portion']).to eq 'Sorvete de chocolate - 1 bola'
      expect(json_response['items'][0]['qty']).to eq 1
      expect(json_response['items'][0]['description']).to eq 'Calda de café'
      expect(json_response['items'][1]['portion']).to eq 'Sorvete de chocolate - 3 bolas'
      expect(json_response['items'][1]['qty']).to eq 2
      expect(json_response['items'][2]['portion']).to eq 'Coca cola - Lata'
      expect(json_response['items'][2]['qty']).to eq 1
      expect(json_response['items'][2]['description']).to eq 'Extremamente gelada'
    end

    it 'e o pedido está vazio' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_email: 'pedro@outlook.com',
                            customer_name: 'Pedro', status: :confirming)

      get "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(json_response['message']).to eq 'O pedido está vazio'
    end
  end
end