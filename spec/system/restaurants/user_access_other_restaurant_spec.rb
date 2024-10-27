require 'rails_helper'


describe 'Usuário entra na aplicação' do
  it 'e tenta acessar outro restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    other_restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                          registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                          phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path other_restaurant
    
    expect(current_path).to eq restaurant_path restaurant
    expect(page).to have_content 'Você não tem acesso à esse restaurante.'
  end
end