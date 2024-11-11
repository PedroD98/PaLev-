require 'rails_helper'

describe 'Usuário cadastra uma bebida' do
  it 'a partir da menu' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'
    click_on 'Registre uma bebida'

    expect(current_path).to eq new_beverage_path
    expect(page).to have_content 'Registre uma bebida:'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Calorias'
    expect(page).to have_content 'Contém álcool?'
    expect(page).to have_button 'Enviar'
  end

  it 'e adiciona um bebida ao restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit new_beverage_path
    fill_in 'Nome da bebida', with: 'Coca lata'
    fill_in 'Descrição', with: 'Coquinha gelada.'
    fill_in 'Calorias', with: 139
    click_on 'Enviar'

    expect(page).to have_content 'Bebida registrada com sucesso!'
    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Coca lata'
    expect(page).to have_content 'Coquinha gelada.'
    expect(page).to have_content 'Calorias: 139 kcal'
    expect(page).to have_content 'Contém álcool: Não'
    expect(page).to have_link 'Lista de itens'
  end

  it 'e adiciona um bebida alcoólica ao restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit new_beverage_path
    fill_in 'Nome da bebida', with: 'Coca lata'
    fill_in 'Descrição', with: 'Coquinha gelada.'
    fill_in 'Calorias', with: 139
    check 'Contém álcool'
    click_on 'Enviar'

    expect(page).to have_content 'Bebida registrada com sucesso!'
    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Coca lata'
    expect(page).to have_content 'Coquinha gelada.'
    expect(page).to have_content 'Calorias: 139 kcal'
    expect(page).to have_content 'Contém álcool: Sim'
    expect(page).to have_link 'Lista de itens'
  end

  it 'e preenche os campos obrigatórios' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit new_beverage_path
    fill_in 'Nome da bebida', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: 274
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao registrar bebida.'
    expect(page).to have_content 'Nome da bebida não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Registre uma bebida:'
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
    visit new_beverage_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end
end