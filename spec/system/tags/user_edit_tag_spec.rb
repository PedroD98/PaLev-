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
end