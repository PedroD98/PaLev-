require 'rails_helper'

describe 'usuário cadastra um desconto' do
  it 'e precisa estar logado' do
    visit new_discount_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e formulário existe' do
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
    click_on 'Clique aqui'

    expect(current_path).to eq new_discount_path
    expect(page).to have_content 'Nome'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Porcentagem do desconto'
    expect(page).to have_field 'Data de início'
    expect(page).to have_field 'Data de encerramento'
    expect(page).to have_field 'Limite de uso'
    expect(page).to have_button 'Criar desconto'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_discount_path
    fill_in 'Nome', with: 'Semana da Batata'
    fill_in 'Porcentagem do desconto', with: 15
    fill_in 'Data de início', with: Date.today
    fill_in 'Data de encerramento', with: Date.tomorrow
    fill_in 'Limite de uso', with: 100
    click_on 'Criar desconto'
    discount = restaurant.discounts.last

    expect(current_path).to eq discount_path(discount)
    expect(page).to have_content 'Desconto criado com sucesso!'
    expect(page).to have_content 'Desconto: Semana da Batata'
    expect(page).to have_content 'Porcentagem do desconto: 15%'
    expect(page).to have_content "Início: #{Date.today.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Encerramento: #{Date.tomorrow.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Limite de uso: 100'
    expect(page).to have_link 'Voltar'
  end

  it 'e não preenche os campos obrigatórios' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit new_discount_path
    fill_in 'Nome', with: ''
    fill_in 'Porcentagem do desconto', with: ''
    fill_in 'Data de início', with: ''
    fill_in 'Data de encerramento', with: ''
    click_on 'Criar desconto'

    expect(restaurant.discounts.count).to eq 0
    expect(page).to have_content 'Novo desconto:'
    expect(page).to have_content 'Falha ao criar desconto.'
    expect(page).to have_content "Nome não pode ficar em branco"
    expect(page).to have_content "Porcentagem do desconto não pode ficar em branco"
    expect(page).to have_content "Data de início não pode ficar em branco"
    expect(page).to have_content "Data de encerramento não pode ficar em branco"
    expect(page).not_to have_content "Limite de uso não pode ficar em branco"
  end
end