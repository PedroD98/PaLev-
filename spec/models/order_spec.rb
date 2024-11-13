require 'rails_helper'

describe '#valid' do
  context 'presence' do
    it 'falso se nome estiver em branco' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.new(restaurant: restaurant, customer_name: '', customer_social_number: '',
                        customer_email: 'ana@gmail.com', customer_phone: '21222704555')
      
      expect(order).not_to be_valid
      expect(order.errors.include? :customer_name).to be true
    end

    it 'falso quando telefone e e-mail estiverem em branco' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.new(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                        customer_email: '', customer_phone: '')

      expect(order).not_to be_valid
      expect(order.errors.include? :base).to be true
    end

    it 'verdadeiro quando apenas o telefone e nome forem preenchidos' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.new(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '',
                        customer_email: '', customer_phone: '21222704555')
      
      expect(order).to be_valid
    end

    it 'verdadeiro quando apenas o e-mail e nome forem preenchidos' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                      registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                      phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      order = Order.new(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '',
                        customer_email: 'ana@gmail.com', customer_phone: '')

      expect(order).to be_valid
    end
  end

  it 'falso quando CPF for inválido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                      email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.new(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '111.111.111-11',
                      customer_email: 'ana@gmail.com', customer_phone: '21222704555')

    expect(order).not_to be_valid
    expect(order.errors.include? :customer_social_number).to be true
  end

  it 'falso quando telefone for inválido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                      email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.new(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                      customer_email: 'ana@gmail.com', customer_phone: '212-7670790')

    expect(order).not_to be_valid
    expect(order.errors.include? :customer_phone).to be true
  end  

  it 'código único é gerado corretamente' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                      email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '756.382.144-96',
                          customer_email: 'ana@gmail.com', customer_phone: '21222704555')
    other_order = Order.create!(restaurant: restaurant, customer_name: 'Maria', customer_social_number: '621.271.587-41',
                                customer_email: 'maria@gmail.com', customer_phone: '2197456244')

    expect(other_order.code).not_to eq order.code
    expect(other_order.code.length).to eq 8
    expect(other_order.code).to match (/\A[A-Z0-9]*\z/)
  end
end