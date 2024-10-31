require 'rails_helper'

describe 'Usuário acessa um item de outra pessoa' do
  it 'e tenta excluir um prato' do
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
    delete(dish_path(dish.id))

    expect(response).to redirect_to items_path
    expect(Dish.exists?(dish.id)).to eq true
  end

  it 'e tenta excluir uma bebida' do
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
    delete(beverage_path(beverage.id))

    expect(response).to redirect_to items_path
    expect(Beverage.exists?(beverage.id)).to eq true
  end
end