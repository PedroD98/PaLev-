require 'rails_helper'

describe 'Usuário edita uma bebida' do
  it 'e página de edição existe' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coca lata'
    click_on 'Editar item'

    expect(page).to have_content 'Editar bebida'
    expect(page).to have_field 'Nome', with: 'Coca lata'
    expect(page).to have_field 'Descrição', with: 'Coquinha gelada'
    expect(page).to have_field 'Calorias', with: 139
    expect(page).to have_field 'Contém álcool'
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
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coca lata'
    click_on 'Editar item'
    fill_in 'Nome', with: 'Cerveja'
    fill_in 'Descrição', with: 'Cerveja gelada'
    fill_in 'Calorias', with: 470
    click_on 'Enviar'

    expect(page).to have_content 'Bebida editada com sucesso!'
    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Cerveja'
    expect(page).to have_content 'Cerveja gelada'
    expect(page).to have_content 'Calorias: 470 kcal'
    expect(page).to have_link 'Voltar para o menu'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coca lata'
    click_on 'Editar item'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: 'Cerveja gelada'
    fill_in 'Calorias', with: 470
    click_on 'Enviar'

    expect(page).to have_content 'Falha ao editar bebida.'
    expect(page).to have_field 'Nome', with: ''
    expect(page).to have_field 'Descrição', with: 'Cerveja gelada'
    expect(page).to have_field 'Calorias', with: 470
    expect(page).to have_button 'Enviar'
  end

  it 'e cancela a edição' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    click_on 'Menu do restaurante'
    click_on 'Coca lata'
    click_on 'Editar item'
    click_on 'Cancelar edição'

    expect(page).to have_content 'Detalhes do item:'
    expect(page).to have_content 'Coca lata'
    expect(page).to have_content 'Coquinha gelada'
    expect(page).to have_content 'Calorias: 139 kcal'
    expect(page).to have_content 'Contém álcool: Não'
    expect(page).to have_link 'Voltar para o menu'
  end
end