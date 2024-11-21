require 'rails_helper'

describe 'usuário acessa página de descontos' do
  it 'e precisar estar logado' do
    visit discounts_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser o dono do restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    employee = Employee.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                                email: 'pedro@email.com', password: 'passwordpass', restaurant: restaurant,
                                registered_restaurant: true)

    login_as employee
    visit discounts_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Gerenciar descontos'
    end

    expect(current_path).to eq discounts_path
    expect(page).to have_content 'Nenhum desconto ativo no momento'
    expect(page).to have_link 'Clique aqui'
  end

  it 'e apenas descontos válidos são listados' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Discount.create!(restaurant: restaurant, name: 'Desconto da batata', discount_amount: 20, 
                     starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
    Discount.create!(restaurant: restaurant, name: 'Refrigerantes', discount_amount: 12, 
                     starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
    discount = Discount.create!(restaurant: restaurant, name: 'Promoção maluca', discount_amount: 50, 
                                starting_date: Date.today, ending_date: Date.tomorrow, max_use: 10)
    discount.update(remaining_uses: 0)
    travel 1.week do
      Discount.create!(restaurant: restaurant, name: 'Viajante do tempo', discount_amount: 10, 
                       starting_date: Date.today, ending_date: Date.tomorrow)
    end
    
    login_as user
    visit discounts_path

    expect(restaurant.discounts.count).to eq 4
    expect(page).to have_link 'Desconto da batata'
    expect(page).to have_link 'Refrigerantes'
    expect(page).not_to have_link 'Promoção maluca'
    expect(page).not_to have_link 'Viajante do tempo'
  end
end