require 'rails_helper'

describe 'Usuário registra prato' do
  it 'e marcadores aparecem no formulário' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Tag.create!(restaurant: restaurant, name: 'Vegano')
    Tag.create!(restaurant: restaurant, name: 'Sem glúten')


    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'
    click_on 'Registre um prato'

    expect(current_path).to eq new_dish_path
    expect(page).to have_content 'Registre um prato:'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_content 'Marcadores'
    expect(page).to have_field 'Calorias'
    expect(page).to have_button 'Enviar'
  end
end