require 'rails_helper'

describe 'Usuário registra horário de funcionamento' do
  it 'a partir do formulário' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Meu restaurante'
    click_on 'Horário de Funcionamento'
    click_on 'Clique aqui'

    expect(page).to have_content 'Horário de funcionamento:'
    expect(page).to have_content 'Domingo'
    expect(page).to have_content 'Segunda-feira'
    expect(page).to have_content 'Terça-feira'
    expect(page).to have_content 'Quarta-feira'
    expect(page).to have_content 'Quinta-feira'
    expect(page).to have_content 'Sexta-feira'
    expect(page).to have_content 'Sábado'
    expect(page).to have_button 'Registrar'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Meu restaurante'
    click_on 'Horário de Funcionamento'
    click_on 'Clique aqui'
    7.times do |index|
      fill_in "operating_hours[#{index}][open_time]", with: '11:00 AM'
      fill_in "operating_hours[#{index}][close_time]", with: '11:00 PM'
    end
    click_on 'Registrar'

    expect(user.restaurant.operating_hours.count).to eq 7
    expect(page).not_to have_content 'Falha ao registrar horários. Preencha todos os campos.'
    expect(page).to have_content 'Horário de funcionamento:'
    expect(page).to have_content 'Horário de funcionamento registrado com sucesso'
    expect(page).to have_content 'Domingo'
    expect(page).to have_content 'Segunda-feira'
    expect(page).to have_content 'Terça-feira'
    expect(page).to have_content 'Quarta-feira'
    expect(page).to have_content 'Quinta-feira'
    expect(page).to have_content 'Sexta-feira'
    expect(page).to have_content 'Sábado'
  end

  it 'e preenche todos os campos' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit root_path
    click_on 'Meu restaurante'
    click_on 'Horário de Funcionamento'
    click_on 'Clique aqui'
    click_on 'Registrar'
    
    expect(page).to have_content 'Horário de funcionamento:'
    expect(page).to have_content 'Falha ao registrar horários. Preencha todos os campos.'
    expect(page).not_to have_content 'Horário de funcionamento registrado com sucesso'
  end

  it 'e o status do restaurante corresponde corretamente' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), closed: false, restaurant: restaurant)

    login_as user
    visit root_path
    click_on 'Meu restaurante'

    expect(page).to have_content 'Status: Aberto'
  end

  it 'e só pode criá-lo uma vez' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    op = OperatingHour.create!(day_of_week: Date.current.wday, open_time: Time.zone.parse('06:00 AM'),
                               close_time: Time.zone.parse('11:59 PM'), closed: false, restaurant: restaurant)

    login_as user
    visit new_restaurant_operating_hour_path restaurant

    expect(current_path).to eq restaurant_operating_hour_path(restaurant, op)
    expect(page).to have_content 'Seu Horário de funcionamento já foi cadastrado'
  end
end