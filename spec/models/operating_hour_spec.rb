require 'rails_helper'

RSpec.describe OperatingHour, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando close_time está vazio' do
        user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                        registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                        phone_number: '2127670790', address: 'Av Mario, 30', user: user)
        op = OperatingHour.new(day_of_week: 1, open_time: '11:00 AM', close_time: '',
                              closed: false, restaurant: restaurant)

        expect(op).not_to be_valid
      end

      it 'falso quando open_time está vazio' do
        user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                        registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                        phone_number: '2127670790', address: 'Av Mario, 30', user: user)
        op = OperatingHour.new(day_of_week: 2, open_time: '', close_time: '11:00 AM',
                              closed: false, restaurant: restaurant)

        expect(op.close_time).not_to eq nil
        expect(op).not_to be_valid
      end

      it 'falso quando day_of_week está vazio' do
        user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                        registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                        phone_number: '2127670790', address: 'Av Mario, 30', user: user)
        op = OperatingHour.new(day_of_week: '', open_time: '11:00 AM', close_time: '11:00 PM',
                              closed: false, restaurant: restaurant)
        
        expect(op.open_time).not_to eq nil
        expect(op).not_to be_valid
      end

      it 'horários podem ficar em branco quando closed for true' do
        user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                        registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                        phone_number: '2127670790', address: 'Av Mario, 30', user: user)
        op = OperatingHour.new(day_of_week: 0, open_time: '', close_time: '',
                              closed: true, restaurant: restaurant)
        
        expect(op.close_time).to eq nil
        expect(op.open_time).to eq nil
        expect(op).to be_valid
      end
    end

    it 'falso quando horário de fechamento é anterior ao de abertura' do
      user = User.create!(name: 'João', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@gmail.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede McRonald Alimentos', restaurant_name: 'McRonald',
                                      registration_number: '59.541.264/0001-03', email: 'contato@mcronald.com',
                                      phone_number: '2127670790', address: 'Av Mario, 30', user: user)
      op = OperatingHour.new(day_of_week: 0, open_time: '11:00 AM', close_time: '10:59 AM',
                             closed: false, restaurant: restaurant)

      
      expect(op).not_to be_valid
      expect(op.errors.any?).to eq true
    end  
  end
end
