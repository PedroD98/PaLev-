require 'rails_helper'

describe 'Usuário cadastra um restaurante' do
  it 'e deve estar autenticado' do
    visit new_restaurant_path

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do formulário de cadastro' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')

    login_as user
    visit new_restaurant_path
    
    expect(page).to have_content 'Boas vindas ao PaLevá'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'
    expect(page).to have_button 'Registrar Restaurante'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')

    login_as user
    visit new_restaurant_path
    fill_in 'Razão Social', with: 'Rede RonaldMc Alimentos'
    fill_in 'Nome Fantasia', with: 'RonaldMc'
    fill_in 'CNPJ', with: '41.684.415/0001-09'
    fill_in 'Endereço', with: 'Av Dr. Mário Guimarães, 40'
    fill_in 'Telefone', with: '2122870749'
    fill_in 'E-mail', with: 'contato@RonaldMc.com'
    click_on 'Registrar Restaurante'
    user.reload
    
    expect(user.registered_restaurant).to eq true
    expect(page).to have_content 'Restaurante registrado com sucesso.'
    expect(page).to have_content 'RonaldMc'
    expect(page).to have_content 'Rede RonaldMc Alimentos'
    expect(page).to have_content '41.684.415/0001-09'
    expect(page).to have_content 'Av Dr. Mário Guimarães, 40'
    expect(page).to have_content '2122870749'
    expect(page).to have_content 'contato@RonaldMc.com'
    expect(page).to have_content "#{user.restaurant.code}"
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')

    login_as user
    visit new_restaurant_path
    fill_in 'Razão Social', with: 'Rede RonaldMc Alimentos'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: 'Av Dr. Mário Guimarães, 40'
    fill_in 'Telefone', with: '2122870749'
    fill_in 'E-mail', with: 'contato@RonaldMc.com'
    click_on 'Registrar Restaurante'

    
    expect(Restaurant.count).to eq 0
    expect(page).to have_content 'Falha ao registrar restaurante.'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'CNPJ não é válido'
    expect(page).to have_field with: 'Rede RonaldMc Alimentos'
    expect(page).to have_field with: 'Av Dr. Mário Guimarães, 40'
    expect(page).to have_field with: '2122870749'
    expect(page).to have_field with: 'contato@RonaldMc.com'
  end

  it 'e pode cadastrar apenas um' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2127960790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit new_restaurant_path

    expect(current_path).to eq restaurant_path(user.restaurant.id)
    expect(page).to have_content 'Já existe um restaurante vinculado à essa conta.'
    expect(page).not_to have_content 'Cadastre seu Restaurante!'
  end

  it 'e precisa cadastrar um restaurante antes de seguir em frente' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2127960790', address: 'Av Mario, 30', user: user)

    login_as other_user
    visit restaurant_path(user.restaurant.id)

    expect(current_path).to eq new_restaurant_path
    expect(page).to have_content 'Antes de seguir em frente, precisamos que você cadastre seu restaurante.'
    expect(page).to have_content 'Vamos cadastrar seu estabelecimento.'
  end

  it 'e é vinculado como dono do restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')

    login_as user
    visit new_restaurant_path
    fill_in 'Razão Social', with: 'Rede RonaldMc Alimentos'
    fill_in 'Nome Fantasia', with: 'RonaldMc'
    fill_in 'CNPJ', with: '41.684.415/0001-09'
    fill_in 'Endereço', with: 'Av Dr. Mário Guimarães, 40'
    fill_in 'Telefone', with: '2122870749'
    fill_in 'E-mail', with: 'contato@RonaldMc.com'
    click_on 'Registrar Restaurante'
    position = Position.last
    user.reload

    expect(position.description).to eq 'Dono'
    expect(user.position.description).to eq 'Dono'
    expect(user.is_owner).to eq true
  end
end