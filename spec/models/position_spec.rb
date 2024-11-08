require 'rails_helper'

describe '#valid' do
  it 'falso quando descição do cargo fica em branco' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.new(restaurant: restaurant, description: '')

    expect(position).not_to be_valid
    expect(position.errors.include? :description).to eq true
  end

  it 'falso quando descição do cargo já está em uso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Gerente')
    position = Position.new(restaurant: restaurant, description: 'Gerente')

    expect(position).not_to be_valid
    expect(position.errors.include? :description).to eq true
  end
end