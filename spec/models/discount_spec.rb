require 'rails_helper'

describe '#valid' do
  it 'falso quando nome estiver em branco' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.new(restaurant: restaurant, name: '', discount_amount: 15, 
                            starting_date: Date.today, ending_date: Date.tomorrow)

    expect(discount).not_to be_valid
    expect(discount.errors.include? :name).to be true
  end

  it 'falso quando data de início estiver em branco' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.new(restaurant: restaurant, name: 'Semana do suco', discount_amount: 15, 
                            starting_date: '', ending_date: Date.tomorrow)

    expect(discount).not_to be_valid
    expect(discount.errors.include? :starting_date).to be true
  end

  it 'falso quando data de encerramento estiver em branco' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.new(restaurant: restaurant, name: 'Semana do suco', discount_amount: 15, 
                            starting_date: Date.today, ending_date: '')

    expect(discount).not_to be_valid
    expect(discount.errors.include? :ending_date).to be true
  end

  it 'falso quando data de encerramento for anterior à data de início' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    discount = Discount.new(restaurant: restaurant, name: 'Semana do suco', discount_amount: 15, 
                            starting_date: Date.tomorrow, ending_date: Date.yesterday)

    expect(discount).not_to be_valid
    expect(discount.errors.include? :base).to be true
    expect(discount.errors.full_messages).to include 'Data de encerramento não pode ser anterior à data de início.'
  end
  
end