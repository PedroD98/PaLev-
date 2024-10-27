require 'rails_helper'

describe '#valid' do
  context 'presence' do
    it 'falso quando nome está vazio' do
      user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                      registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                      phone_number: '2127670790', address: 'Av Mario, 30', user: user)
      beverage = Beverage.new(restaurant_id: restaurant.id, name: '', description: 'Coquinha gelada', calories: 139)

     expect(beverage).not_to be_valid
     expect(beverage.errors.include? :name).to be true
    end

    it 'falso quando descrição está vazio' do
      user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                      registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                      phone_number: '2127670790', address: 'Av Mario, 30', user: user)
      beverage = Beverage.new(restaurant_id: restaurant.id, name: 'Budlight', description: '', calories: 340, alcoholic: true)

     expect(beverage).not_to be_valid
     expect(beverage.errors.include? :description).to be true
    end

    it 'válido se calorias ficar vazio' do
      user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                      registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                      phone_number: '2127670790', address: 'Av Mario, 30', user: user)
      beverage = Beverage.new(restaurant_id: restaurant.id, name: 'Coca lata', description: 'Coquinha gelada', calories: '')

     expect(beverage).to be_valid
     expect(beverage.errors.include? :calories).to be false
    end
  end

  it 'falso quando nome já estiver em uso' do
    user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                    registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                    phone_number: '2127670790', address: 'Av Mario, 30', user: user)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata', description: 'Coquinha gelada', calories: 139)
    beverage = Beverage.new(restaurant_id: restaurant.id, name: 'Coca lata', description: 'Coquinha quente', calories: 139)

   expect(beverage).not_to be_valid
   expect(beverage.errors.include? :name).to be true
  end
end