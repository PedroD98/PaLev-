require 'rails_helper'


describe 'Usuário busca por itens' do
  it 'e deve estar logado' do
    visit root_path

    expect(page).not_to have_content 'Buscar no menu'
    expect(page).not_to have_button 'Buscar'
  end
  
  it 'e barra de busca existe' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)

    login_as user
    visit restaurant_path restaurant
    
    within 'nav' do
      expect(page).to have_content 'Buscar no menu'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'e encontra o item buscado' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango', calories: 274)
    Dish.create!(restaurant_id: restaurant.id, name: 'Bolinho de bacalhau', 
                 description: 'Bolinho de bacalhau fresco', calories: 198)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    fill_in 'Buscar no menu', with: 'Coxinha'
    click_on 'Buscar'
    
    expect(page).to have_content '1 item encontrado'
    expect(page).to have_link 'Coxinha'
    expect(page).to have_link 'Editar Coxinha'
    expect(page).not_to have_link 'Coca lata'
    expect(page).not_to have_link 'Bolinho de bacalhau'
  end

  it 'e encontra os itens correspondentes partir da descrição' do
    user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                        email: 'pedro@email.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede RonaldMc Alimentos', restaurant_name: 'RonaldMc',
                                    registration_number: '41.684.415/0001-09', email: 'contato@RonaldMc.com',
                                    phone_number: '2128270790', address: 'Av Mario, 30', user: user)
    user.update(registered_restaurant: true)
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango com massa feita no dia', calories: 274)
    Dish.create!(restaurant_id: restaurant.id, name: 'Bolinho de bacalhau', 
                 description: 'Bolinho de bacalhau fresco com massa feita no dia', calories: 198)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)

    login_as user
    visit restaurant_path restaurant
    fill_in 'Buscar no menu', with: 'massa'
    click_on 'Buscar'
    
    expect(page).to have_content '2 itens encontrados'
    expect(page).to have_link 'Coxinha'
    expect(page).to have_link 'Editar Coxinha'
    expect(page).to have_link 'Bolinho de bacalhau'
    expect(page).to have_link 'Editar Bolinho de bacalhau'
    expect(page).not_to have_link 'Coca lata'
  end

  it 'e não visualiza os itens de outro restaurante' do
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
    Dish.create!(restaurant_id: restaurant.id, name: 'Coxinha', 
                 description: 'Coxinha de frango com massa feita no dia', calories: 274)
    Beverage.create!(restaurant_id: restaurant.id, name: 'Coca lata',
                     description: 'Coquinha gelada', calories: 139)
    Dish.create!(restaurant_id: other_restaurant.id, name: 'Croquete', 
                 description: 'Croquete de carne com massa feita no dia', calories: 198)

    login_as user
    visit restaurant_path restaurant
    fill_in 'Buscar no menu', with: 'massa'
    click_on 'Buscar'
    
    expect(page).to have_content '1 item encontrado'
    expect(page).to have_link 'Coxinha'
    expect(page).to have_link 'Editar Coxinha'
    expect(page).not_to have_link 'Bolinho de bacalhau'
    expect(page).not_to have_link 'Editar Bolinho de bacalhau'
    expect(page).not_to have_link 'Coca lata'
  end
end