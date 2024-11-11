require 'rails_helper'

describe 'Funcionário faz login' do
  it 'e vê menu limitado' do
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
    save_page

    expect(Employee.all.count).to eq 1
    expect(User.all.count).to eq 2
    # o resultado deveria ser 1, mas o teste retorna 0
    expect(restaurant.employees.count).to eq 1
    expect(page).to have_link 'Meu restaurante'
    expect(page).to have_link 'Meu perfil'
    expect(page).to have_link 'Cardápios'
    expect(page).to have_link 'Pedidos'
    expect(page).not_to have_link 'Lista de itens'
    expect(page).not_to have_link 'Cargos'
    expect(page).not_to have_link 'Gerenciar marcadores'
    expect(page).not_to have_link 'Pré-cadastros'
    expect(page).not_to have_content 'Buscar no menu'

    
    click_on 'Sair'
    click_on 'Entrar'
    fill_in 'E-mail', with: 'kariny@gmail.com'
    fill_in 'Senha', with: 'passwordpass'
    click_on 'Entrar'
    
    expect(current_path).to eq root_path
    expect(page).to have_link 'Meu restaurante'
    expect(page).to have_content 'Kariny'
  end
end