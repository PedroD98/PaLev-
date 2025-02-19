require 'rails_helper'

describe 'Order API' do
  context 'GET api/v1/restaurants/:restaurant_code/orders' do
    it 'erro se código do restaurante for inválido ou não informado' do
      get '/api/v1/restaurants/ABC1234/orders'

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 404
      expect(json_response['error']).to eq 'Restaurante não encontrado'
    end

    it 'lista pedidos do restaurante correto' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_email: 'ana@gmail.com', status: :done)
      order_2 = Order.create!(restaurant: restaurant, customer_name: 'Maria',  customer_email: 'maria@gmail.com', status: :confirming)
      other_user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                                email: 'pedro@email.com', password: 'passwordpass')
      other_restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                            registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                            phone_number: '2128270790', address: 'Av Mario, 30', user: other_user)
      Order.create!(restaurant: other_restaurant, customer_name: 'João',  customer_email: 'joão@yahoo.com', status: :canceled)

      get "/api/v1/restaurants/#{restaurant.code}/orders"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['orders'].length).to eq 2
      expect(json_response['orders'][0]['customer_email']).to eq 'ana@gmail.com'
      expect(json_response['orders'][0]['code']).to eq "#{order_1.code}"
      expect(json_response['orders'][0]['status']).to eq "Pronto"
      expect(json_response['orders'][1]['customer_email']).to eq 'maria@gmail.com'
      expect(json_response['orders'][1]['code']).to eq "#{order_2.code}"
      expect(json_response['orders'][1]['status']).to eq "Aguardando confirmação da cozinha"
    end

    it 'retorna [] se não há pedidos' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      
      get "/api/v1/restaurants/#{restaurant.code}/orders"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['orders']).to eq []
    end

    it 'lista pedidos filtrados' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      Order.create!(restaurant: restaurant, customer_name: 'Ana',  customer_email: 'ana@gmail.com', status: :creating)
      Order.create!(restaurant: restaurant, customer_name: 'Maria',  customer_email: 'maria@gmail.com', status: :confirming)
      Order.create!(restaurant: restaurant, customer_name: 'Pedro',  customer_email: 'pedro@bing.com', status: :preparing)
      Order.create!(restaurant: restaurant, customer_name: 'Arthur',  customer_email: 'arthur@outlook.com', status: :done)
      Order.create!(restaurant: restaurant, customer_name: 'João',  customer_email: 'joão@yahoo.com', status: :canceled)

      get "/api/v1/restaurants/#{restaurant.code}/orders", params: { status_filters: [:creating, :confirming, :preparing] }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['orders'].length).to eq 3
      expect(json_response['orders'][0]['status']).to eq 'Em criação'
      expect(json_response['orders'][1]['status']).to eq 'Aguardando confirmação da cozinha'
      expect(json_response['orders'][2]['status']).to eq 'Em preparação'
    end

    it 'lista todos os pedidos se filtro for inválido ou vazio' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      Order.create!(restaurant: restaurant, customer_name: 'Ana',  customer_email: 'ana@gmail.com', status: :creating)
      Order.create!(restaurant: restaurant, customer_name: 'Maria',  customer_email: 'maria@gmail.com', status: :confirming)
      Order.create!(restaurant: restaurant, customer_name: 'Pedro',  customer_email: 'pedro@bing.com', status: :preparing)
      Order.create!(restaurant: restaurant, customer_name: 'Arthur',  customer_email: 'arthur@outlook.com', status: :done)
      Order.create!(restaurant: restaurant, customer_name: 'João',  customer_email: 'joão@yahoo.com', status: :canceled)

      get "/api/v1/restaurants/#{restaurant.code}/orders", params: { status_filters: [:confirming, :invalid_filter] }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['orders'].length).to eq 5
    end

    it 'e retorna internal error' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      allow(Order).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      
      get "/api/v1/restaurants/#{restaurant.code}/orders"

      expect(response).to have_http_status(500)
    end
  end
end