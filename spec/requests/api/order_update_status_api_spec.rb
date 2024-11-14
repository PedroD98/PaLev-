require 'rails_helper'

describe 'Order API' do
  context 'PATCH apí/v1/restaurants/:restaurant_code/orders/:order_code/preparing' do
    it 'falha se pedido não for encontrado' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

      patch "/api/v1/restaurants/#{restaurant.code}/orders/EX12345A/preparing"

      expect(response.status).to eq 404
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Pedido não encontrado' 
    end

    it 'altera o status para Em preparação com sucesso' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_name: 'Pedro', customer_email: 'pedro@outlook.com', status: :confirming)
      dish = Dish.create!(restaurant_id: restaurant.id, name: 'Sorvete de chocolate', 
                          description: 'Sorvete belga')
      portion = Portion.create!(item: dish, description: '1 bola', price: 6.90)
      OrderPortion.create!(order: order, portion: portion, qty: 1, description: 'Calda de café')
      
      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/preparing"
      order.reload

      expect(order.status).to eq 'preparing'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Status do pedido atualizado com sucesso'
    end

    it 'pedido não pode estar vazio' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_name: 'Pedro',  customer_email: 'pedro@outlook.com', status: :confirming)
      
      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/preparing"
      order.reload

      expect(order.status).to eq 'confirming'
      json_response = JSON.parse(response.body)
      expect(json_response['errors'].length).to eq 1
      expect(json_response['errors'][0]).to eq 'Pedido não pode estar vazio' 
    end

    it 'status do pedido deve ser Aguardando confirmação da cozinha' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_name: 'Pedro',  customer_email: 'pedro@outlook.com', status: :creating)
      dish = Dish.create!(restaurant_id: restaurant.id, name: 'Sorvete de chocolate', 
                          description: 'Sorvete belga')
      portion = Portion.create!(item: dish, description: '1 bola', price: 6.90)
      OrderPortion.create!(order: order, portion: portion, qty: 1, description: 'Calda de café')
      
      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/preparing"
      order.reload

      expect(order.status).to eq 'creating'
      json_response = JSON.parse(response.body)
      expect(json_response['errors'].length).to eq 1
      expect(json_response['errors'][0]).to eq 'Ação só pode ser feita em pedidos com status: Aguardando confirmação da cozinha' 
    end
  end

  context 'PATCH apí/v1/restaurants/:restaurant_code/orders/:order_code/done' do
    it 'falha se pedido não for encontrado' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

      patch "/api/v1/restaurants/#{restaurant.code}/orders/EX12345A/done"

      expect(response.status).to eq 404
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Pedido não encontrado' 
    end
    
    it 'altera o status para Pronto com sucesso' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_name: 'Pedro', customer_email: 'pedro@outlook.com', status: :preparing)
      dish = Dish.create!(restaurant_id: restaurant.id, name: 'Picanha', 
                          description: 'Picanha na pedra')
      portion = Portion.create!(item: dish, description: 'Família', price: 150)
      OrderPortion.create!(order: order, portion: portion, qty: 1, description: 'Ao ponto')
      
      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/done"
      order.reload

      expect(order.status).to eq 'done'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Status do pedido atualizado com sucesso'
    end

    it 'status do pedido deve ser Aguardando confirmação da cozinha' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.create!(restaurant: restaurant, customer_name: 'Pedro',  customer_email: 'pedro@outlook.com', status: :canceled)
      dish = Dish.create!(restaurant_id: restaurant.id, name: 'Picanha', 
                          description: 'Picanha na pedra')
      portion = Portion.create!(item: dish, description: 'Família', price: 150)
      OrderPortion.create!(order: order, portion: portion, qty: 1, description: 'Ao ponto')
      
      patch "/api/v1/restaurants/#{restaurant.code}/orders/#{order.code}/done"
      order.reload

      expect(order.status).to eq 'canceled'
      json_response = JSON.parse(response.body)
      expect(json_response['errors'].length).to eq 1
      expect(json_response['errors'][0]).to eq 'Ação só pode ser feita em pedidos com status: Em preparação' 
    end
  end
end
