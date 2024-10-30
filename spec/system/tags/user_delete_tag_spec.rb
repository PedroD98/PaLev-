require 'rails_helper'

describe 'Usuário deleta um marcador' do
  it 'com sucesso' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Tag.create!(restaurant: restaurant, name: 'Vegano')

    login_as user
    visit root_path
    click_on 'Gerenciar marcadores'
    click_on 'Excluir marcador'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Marcador removido com sucesso!'
    expect(page).not_to have_content 'Vegano'
  end
end