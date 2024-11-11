require 'rails_helper'

describe 'Usuário registra marcadores' do
  it 'a partir do formulário' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Clique aqui'


    expect(page).to have_content 'Novo marcador'
    expect(page).to have_field   'Nome'
    expect(page).to have_button 'Enviar'
  end
  
  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Clique aqui'
    fill_in 'Nome', with: 'Vegano'
    click_on 'Enviar'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Marcadores:'
    expect(page).to have_content 'Marcador registrado com sucesso!'
    expect(page).to have_content 'Vegano'
    expect(page).to have_link   'Novo marcador'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Clique aqui'
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Novo marcador'
    expect(page).to have_content 'Falha ao registrar marcador.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_field 'Nome'
  end

  it 'e precisa ser o dono do restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    employee = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                            email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    employee.restaurant = restaurant


    login_as employee
    visit new_tag_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end
end