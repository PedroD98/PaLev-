require 'rails_helper'

describe 'Usuário edita marcadores' do
  it 'e tela de edição existe' do
   user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Tag.create!(restaurant: restaurant, name: 'Sem glúten')

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Editar'

    expect(page).to have_content 'Editar marcador: Sem glúten'
    expect(page).to have_field 'Nome',with: 'Sem glúten'
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
    Tag.create!(restaurant: restaurant, name: 'Sem glúten')

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Editar'
    fill_in 'Nome', with: 'Apimentado'
    click_on 'Enviar'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Apimentado'
    expect(page).not_to have_content 'Sem glúten'
  end

  it 'e precisa ser o dono do restaurante' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    tag = Tag.create!(restaurant: restaurant, name: 'Sem glúten')
    employee = Employee.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', is_owner: false,
                                email: 'pedro@email.com', password: 'passwordpass', restaurant: restaurant,
                                registered_restaurant: true)


    login_as employee
    visit edit_tag_path tag

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página.'
  end
end