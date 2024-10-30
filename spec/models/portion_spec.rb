require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando descrição ficar em branco' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                        registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                        phone_number: '2128270790', address: 'Av Mario, 30', user: user)
        user.update(registered_restaurant: true)
        dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                            description: 'Croquete de carne', calories: 274)
        portion = Portion.new(item: dish, description: '', price: 10.00)

        
        expect(portion).not_to be_valid
        expect(portion.errors.include? :description).to eq true
      end

      it 'falso quando preço ficar em branco' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                        registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                        phone_number: '2128270790', address: 'Av Mario, 30', user: user)
        user.update(registered_restaurant: true)
        beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Fanta', 
                            description: 'Fanta laranja lata', calories: 300)
        portion = Portion.new(item: beverage, description: '3 unid.', price: '')

        
        expect(portion).not_to be_valid
        expect(portion.errors.include? :price).to eq true
      end
    end

    context 'uniqueness' do
      it 'falso quando descrição está sendo usada por outra porção do item' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                        registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                        phone_number: '2128270790', address: 'Av Mario, 30', user: user)
        user.update(registered_restaurant: true)
        dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                            description: 'Croquete de carne', calories: 274)
        Portion.create!(item: dish, description: '3 unid', price: 10.00)
        other_portion = Portion.new(item: dish, description: '3 unid', price: 4.00)

        
        expect(other_portion).not_to be_valid
        expect(other_portion.errors.include? :description).to eq true
      end
    end

    it 'falso quando preço for negativo' do
      user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                      email: 'pedro@email.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                      registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                      phone_number: '2128270790', address: 'Av Mario, 30', user: user)
      user.update(registered_restaurant: true)
      beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Fanta', 
                          description: 'Fanta laranja lata', calories: 300)
      portion = Portion.new(item: beverage, description: '3 unid.', price: -10.00)

      
      expect(portion).not_to be_valid
      expect(portion.errors.include? :price).to eq true
    end
  end
end
