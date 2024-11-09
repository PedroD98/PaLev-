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
    save_page

    expect(current_path).to eq pre_registers_path
    expect(page).to have_content 'Nenhum pré-cadastro realizado.'
    expect(page).to have_content 'Faça o pré-cadastro de um funcionário'
    expect(page).to have_link 'clicando aqui'
  end

  it 'e lista de funcionários pré-cadastrados é exibida' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Gerente')
    PreRegister.create!(restaurant: restaurant, user: user, position: position,
                        employee_social_number: '121.538.978-74', employee_email: 'pedro@gmail.com')
    PreRegister.create!(restaurant: restaurant, user: user, position: position,
                        employee_social_number: '946.876.185-10', employee_email: 'ana@gmail.com')

    login_as user
    visit pre_registers_path

    expect(page).to have_content 'Funcionários pré-cadastrados'
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'pedro@gmail.com'
    expect(page).to have_content 'ana@gmail.com'
    expect(page).to have_content 'CPF'
    expect(page).to have_content '121.538.978-74'
    expect(page).to have_content '946.876.185-10'
    expect(page).to have_content 'Cargo'
    expect(page).to have_content 'Gerente'
    expect(page).to have_content 'Status da conta'
    expect(page).to have_content 'Não cadastrada'
  end
end