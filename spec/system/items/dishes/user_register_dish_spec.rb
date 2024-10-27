require 'rails_helper'

describe 'Usuário cadastra um prato' do
  it 'a partir do menu' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Registre um prato'

    expect(current_path).to eq new_dish_path
    expect(page).to have_content 'Registre um prato:'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Calorias'
    expect(page).to have_button 'Enviar'
  end

  it 'e adiciona um prato ao restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Registre um prato'
    fill_in 'Nome do prato', with: 'Coxinha'
    fill_in 'Descrição', with: 'Coxinha de frango com massa feita no dia.'
    fill_in 'Calorias', with: 274
    click_on 'Enviar'

    expect(page).to have_content 'Prato registrado com sucesso!'
    expect(page).to have_content 'Detalhes do prato:'
    expect(page).to have_content 'Coxinha'
    expect(page).to have_content 'Coxinha de frango com massa feita no dia.'
    expect(page).to have_content 'Calorias: 274 kcal'
    expect(page).to have_link 'Voltar para o menu'
  end

  it 'e preenche os campos obrigatórios' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Registre um prato'
    fill_in 'Nome do prato', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: 274
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao registrar prato.'
    expect(page).to have_content 'Nome do prato não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Registre um prato:'
  end
end