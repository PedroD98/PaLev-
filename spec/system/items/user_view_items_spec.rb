require 'rails_helper'


describe 'Usuário acessa sua conta' do
  it 'e tenta visualizar um prato de outro restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')

    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    other_restaurant = Restaurant.create!(legal_name: 'Rede Pizza King Alimentos', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2128245790', address: 'Av Mario, 30', user: other_user)

    dish = Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)
    Dish.create!(restaurant_id: other_restaurant.id, name: 'Coxinha', 
                        description: 'Coxinha de frango', calories: 274)
    user.update(registered_restaurant: true)
    other_user.update(registered_restaurant: true)



    login_as other_user
    visit dish_path(dish.id)

    expect(current_path).to eq items_path
  end

  it 'e tenta visualizar uma bebida de outro restaurante' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                              email: 'kariny@gmail.com', password: 'passwordpass')

    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                       registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                       phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    other_restaurant = Restaurant.create!(legal_name: 'Rede Pizza King Alimentos', restaurant_name: 'Pizza King',
                       registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                       phone_number: '2128245790', address: 'Av Mario, 30', user: other_user)

    beverage = Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                            description: 'Coquinha quente', calories: 139)
    Beverage.create!(restaurant_id: other_restaurant.id, name: 'Pepsi lata',
                     description: 'Pepsi gelada', calories: 128)
    user.update(registered_restaurant: true)
    other_user.update(registered_restaurant: true)



    login_as other_user
    visit beverage_path(beverage.id)

    expect(current_path).to eq items_path
  end
end