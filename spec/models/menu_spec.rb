require 'rails_helper'

describe '#valid' do
  it 'falso quando nome está vazio' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    menu = Menu.new(restaurant: restaurant, name: '')

    expect(menu).not_to be_valid
    expect(menu.errors.include? :name).to be true
  end

  it 'falso quando nome já foi utilizado pelo restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Menu.create!(restaurant: restaurant, name: 'Jantar')
    other_menu = Menu.new(restaurant: restaurant, name: 'Jantar')

    expect(other_menu).not_to be_valid
    expect(other_menu.errors.include? :name).to be true
  end
end