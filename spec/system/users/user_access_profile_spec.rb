require 'rails_helper'


describe 'Usuário faz login' do
  it 'e link do perfil existe' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
     Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                        registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                        phone_number: '2128270790', address: 'Av Mario, 30', user: user)


    login_as user
    visit root_path

    expect(page).to have_link 'Meu perfil'
  end

  it 'e acessa seu perfil' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)

    login_as user
    visit root_path
    click_on 'Meu perfil'

    expect(current_path).to eq user_path user
    expect(page).to have_content 'Detalhes do perfil:'
    expect(page).to have_content 'Nome completo: Pedro Dias'
    expect(page).to have_content 'E-mail: pedro@email.com'
    expect(page).to have_content 'CPF: 133.976.443-13'
    expect(page).to have_content 'Restaurante:'
    expect(page).to have_link 'RonaldMc'
  end

  it 'e não consegue acessar o perfil de outro usuário' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass', registered_restaurant: true)
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    login_as user
    visit user_path other_user

    expect(current_path).to eq user_path user
    expect(page).to have_content 'Você não pode acessar esse perfil'
  end
end