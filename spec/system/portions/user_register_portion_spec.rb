require 'rails_helper'

describe 'Usuário registra uma porção' do
  it 'a partir do menu' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango', calories: 274)

    login_as user
    visit items_path
    click_on 'Coxinha'
    click_on 'Adicionar porção'

    expect(page).to have_content 'Cadastro de porção de Coxinha'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Preço'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)

    login_as user
    visit items_path
    click_on 'Croquete'
    click_on 'Adicionar porção'
    fill_in 'Descrição', with: '6 unid.'
    fill_in 'Preço', with: 38.50
    click_on 'Enviar'

    expect(current_path).to eq item_path(dish)
    expect(page).to have_content 'Porções:'
    expect(page).to have_content '6 unid.'
    expect(page).to have_content 'R$ 38,50'
  end

  it 'e os campos não podem ficar em branco' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                 description: 'Croquete de carne', calories: 274)

    login_as user
    visit items_path
    click_on 'Croquete'
    click_on 'Adicionar porção'
    fill_in 'Descrição', with: ''
    fill_in 'Preço', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao cadastrar porção.'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end

  it 'e precisa ser o dono do restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Croquete', 
                        description: 'Croquete de carne', calories: 274)
    employee = Employee.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                                email: 'pedro@email.com', password: 'passwordpass', restaurant: restaurant,
                                registered_restaurant: true)


    login_as employee
    visit new_item_portion_path dish

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end
end