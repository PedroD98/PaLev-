require 'rails_helper'

describe 'Usuário faz login' do
  it 'e acessa página dos itens' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'

    expect(current_path).to eq items_path
    expect(page).to have_content 'Menu do restaurante:'
    expect(page).to have_content 'Seu restaurante ainda não possui nenhum item.'
    expect(page).to have_link 'Registre um prato'
    expect(page).to have_link 'Registre uma bebida'
  end
end