require 'rails_helper'

describe 'Usuário edita um prato' do
  it 'e página de edição existe' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango', calories: 274)

    login_as user
    visit restaurant_path restaurant
    click_on 'Lista de itens'
    click_on 'Coxinha'
    click_on 'Editar'

    expect(page).to have_content 'Editar prato'
    expect(page).to have_field 'Nome', with: 'Coxinha'
    expect(page).to have_field 'Descrição', with: 'Coxinha de frango'
    expect(page).to have_field 'Calorias', with: 274
    expect(page).to have_button 'Enviar'
    expect(page).to have_link 'Cancelar edição'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)

    login_as user
    visit item_path dish
    click_on 'Editar'
    fill_in 'Nome', with: 'Croquete'
    fill_in 'Descrição', with: 'Croquete de carne'
    fill_in 'Calorias', with: 330
    click_on 'Enviar'

    expect(page).to have_content 'Prato editado com sucesso!'
    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Croquete'
    expect(page).to have_content 'Croquete de carne'
    expect(page).to have_content 'Calorias: 330 kcal'
    expect(page).to have_link 'Voltar para o menu'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)

    login_as user
    visit item_path dish
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: 'Croquete de carne'
    fill_in 'Calorias', with: 330
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao editar prato.'
    expect(page).to have_field 'Nome', with: ''
    expect(page).to have_field 'Descrição', with: 'Croquete de carne'
    expect(page).to have_field 'Calorias', with: 330
    expect(page).to have_button 'Enviar'
  end

  it 'e cancela a edição' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)

    login_as user
    visit item_path dish
    click_on 'Editar'
    click_on 'Cancelar edição'

    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Coxinha'
    expect(page).to have_content 'Coxinha de frango'
    expect(page).to have_content 'Calorias: 274 kcal'
    expect(page).to have_link 'Voltar para o menu'
  end

end