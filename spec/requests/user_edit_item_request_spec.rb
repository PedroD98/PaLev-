require 'rails_helper'

describe 'Usuário acessa um item de outra pessoa' do
  it 'e tenta editar um prato' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)
    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)
    user.update(registered_restaurant: true)
    other_user.update(registered_restaurant: true)


    login_as other_user
    patch(dish_path(dish.id), params: { dish: {name: 'Croquete'} })

    expect(response).to redirect_to items_path
    expect(dish.name).to eq 'Coxinha'
  end

  it 'e tenta editar uma bebida' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                                description: 'Coquinha quente', calories: 139)
    user.update(registered_restaurant: true)
    other_user.update(registered_restaurant: true)


    login_as other_user
    patch(beverage_path(beverage.id), params: { beverage: {name: 'Pepsi lata'} })

    expect(response).to redirect_to items_path
    expect(beverage.name).to eq 'Coca lata'
  end
end