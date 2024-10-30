require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid' do
    it 'falso quando nome estiver vazio' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    tag = Tag.new(restaurant: restaurant, name: '')

    expect(tag).not_to be_valid
    expect(tag.errors.include? :name).to be true
    end

    it 'falso quando restaurante já possuir marcador com o mesmo nome' do
      user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                          email: 'pedro@email.com', password: 'passwordpass')
      restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                      registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                      phone_number: '2128270790', address: 'Av Mario, 30', user: user)
      user.update(registered_restaurant: true)
      Tag.create!(restaurant: restaurant, name: 'Apimentado')
      tag = Tag.new(restaurant: restaurant, name: 'Apimentado')
  
      expect(tag).not_to be_valid
      expect(tag.errors.include? :name).to be true
      end
  end
end
