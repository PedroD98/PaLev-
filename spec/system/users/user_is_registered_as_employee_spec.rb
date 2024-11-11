require 'rails_helper'

describe 'Usuário cria conta' do
  it 'e é registrado como funcionário' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Cozinheiro')
    PreRegister.create!(restaurant: restaurant, user: user, position: position,
                        employee_social_number: '121.538.978-74', employee_email: 'pedro@gmail.com')

    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '121.538.978-74'
    fill_in 'E-mail', with: 'pedro@gmail.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'
    employee = User.last

    expect(current_path).to eq root_path
    expect(employee.is_owner).to eq false
    expect(employee.restaurant.restaurant_name).to eq 'Pizza King'
    expect(employee.position.description).to eq 'Cozinheiro'
  end

  it 'e CPF não confiz com pré-cadastro' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Cozinheiro')
    PreRegister.create!(restaurant: restaurant, user: user, position: position,
                        employee_social_number: '121.538.978-74', employee_email: 'pedro@gmail.com')

    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '133.976.443-13'
    fill_in 'E-mail', with: 'pedro@gmail.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'

    expect(User.all.count). to eq 1
    expect(page).to have_content 'Esse e-mail faz parte de um pré-cadastro. Verifique se o CPF foi digitado corretamente'
  end

  it 'e e-mail não condiz com pré-cadastro' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Cozinheiro')
    PreRegister.create!(restaurant: restaurant, user: user, position: position,
                        employee_social_number: '121.538.978-74', employee_email: 'pedro@gmail.com')

    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '121.538.978-74'
    fill_in 'E-mail', with: 'pedro_ivo_dias@gmail.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'

    expect(User.all.count). to eq 1
    expect(page).to have_content 'Esse CPF faz parte de um pré-cadastro. Verifique se o e-mail foi digitado corretamente'
  end

  it 'e status do pré-cadastro é atualizado' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Cozinheiro')
    pre_register = PreRegister.create!(restaurant: restaurant, user: user, position: position,
                                       employee_social_number: '121.538.978-74', employee_email: 'pedro@gmail.com')

    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '121.538.978-74'
    fill_in 'E-mail', with: 'pedro@gmail.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'
    pre_register.reload

    expect(pre_register.active).to eq true
  end
end