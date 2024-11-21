require 'rails_helper'

describe 'Usuário acessa lista completa de descontos' do
  it 'e precisa estar logado' do
    visit list_discounts_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e todos os descontos são listados' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Discount.create!(restaurant: restaurant, name: 'Desconto da batata', discount_amount: 20, 
                     starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
    Discount.create!(restaurant: restaurant, name: 'Promoção maluca', discount_amount: 50, 
                     starting_date: Date.today, ending_date: Date.tomorrow, max_use: 0)
    travel 1.week do
      Discount.create!(restaurant: restaurant, name: 'Refrigerantes', discount_amount: 12, 
                     starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
      Discount.create!(restaurant: restaurant, name: 'Viajante do tempo', discount_amount: 10, 
                       starting_date: Date.today, ending_date: Date.tomorrow)
    end

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Gerenciar descontos'
    end
    click_on 'Ver histórico de descontos'

    expect(page).to have_content 'Histórico de descontos:'
    expect(page).to have_link 'Desconto da batata'
    expect(page).to have_link 'Refrigerantes'
    expect(page).to have_link 'Promoção maluca'
    expect(page).to have_link 'Viajante do tempo'
    expect(page).to have_link 'Voltar'
  end
end