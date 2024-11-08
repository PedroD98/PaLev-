require 'rails_helper'

describe 'Usuário acessa a página de pré-cadastros' do
  it 'e precisa estar logado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    visit pre_registers_path

    expect(current_path).to eq new_user_session_path
  end
  
  it 'através do menu' do
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

    expect(current_path).to eq pre_registers_path
    expect(page).to have_content 'Nenhum pré-cadastro realizado.'
    expect(page).to have_content 'Faça o pré-cadastro de um funcionário'
    expect(page).to have_link 'clicando aqui.'
  end

  it 'e lista de funcionários pré-cadastrados é exibida' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    login_as user
    visit pre_registers_path

    expect(page).to have_content 'Funcionários pré-cadastrados'
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'Cargo'
    expect(page).to have_content 'Status da conta'
  end
end