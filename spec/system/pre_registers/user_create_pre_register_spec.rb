require 'rails_helper'

describe 'Usuário cria pré-cadastro' do
  it 'e deve estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit new_pre_register_path

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    
    login_as user
    visit root_path
    within 'nav' do
      click_on 'Pré-cadastros'
    end
    click_on 'clicando aqui'

    expect(current_path).to eq new_pre_register_path
    expect(page).to have_content 'Novo pré-cadastro'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'Cargo'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Position.create!(restaurant: restaurant, description: 'Gerente')
    
    login_as user
    visit new_pre_register_path
    fill_in 'CPF', with: '133.976.443-13'
    fill_in 'E-mail', with: 'pedro@gmail.com'
    select 'Gerente', from: 'Cargo'
    click_on 'Enviar'

    expect(current_path).to eq pre_registers_path
    expect(page).to have_content 'Pré-cadastro criado com sucesso!'
    expect(page).to have_content 'pedro@gmail.com'
    expect(page).to have_content '133.976.443-13'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Não cadastrada'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    Position.create!(restaurant: restaurant, description: 'Gerente')
    
    login_as user
    visit new_pre_register_path
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    select 'Gerente', from: 'Cargo'
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao criar pré-cadastro.'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_button 'Enviar'
  end
end