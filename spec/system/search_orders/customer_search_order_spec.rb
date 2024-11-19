require 'rails_helper'

describe 'cliente busca seu pedido' do
  it 'com sucesso' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    order = Order.create!(restaurant: restaurant, customer_name: 'Ana',
                          customer_email: 'ana@gmail.com', status: :creating)
  
    visit search_orders_path
    fill_in 'Código', with: order.code
    click_on 'Buscar'

    expect(page).to have_content 'Pedido encontrado!'
    expect(page).to have_content "Detalhes do seu pedido: #{order.code}"
    expect(page).to have_content 'Estabelecimento: Pizza King'
    expect(page).to have_content 'Endereço: Av Luigi, 30'
    expect(page).to have_content 'Telefone: 2127670444'
    expect(page).to have_content 'E-mail: contato@pizzaking.com'
    expect(page).to have_link 'Buscar outro pedido'
  end

  it 'e pedido não existe' do
    visit search_orders_path
    fill_in 'Código', with: 'R2D2C3PO'
    click_on 'Buscar'

  
    expect(page).to have_content 'Pedido não encontrado.'
    expect(page).not_to have_content 'Detalhes do seu pedido: R2D2C3PO'
  end

  it 'e histórico de horários do pedido existe' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass')
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)

    
    
    travel_to Time.zone.local(2077, 05, 15, 18, 0, 0) do
      order = Order.create!(restaurant: restaurant, customer_name: 'Ana',
                            customer_email: 'ana@gmail.com', status: :delivered)
      order.update(preparing_timestamp: Time.current + 30.minutes)
      order.update(done_timestamp: Time.current + 1.hour)
      order.update(delivered_timestamp: Time.current + 1.hour + 20.minutes)

    
    
      visit search_orders_path
      fill_in 'Código', with: order.code
      click_on 'Buscar'

      expect(page).to have_content "Detalhes do seu pedido: #{order.code}"
      expect(page).to have_content 'STATUS'
      expect(page).to have_content 'DATA - HORÁRIO'
      expect(page).to have_content 'Criado'
      expect(page).to have_content '15/05/2077 - 18:00:00'
      expect(page).to have_content 'Início do preparo'
      expect(page).to have_content '15/05/2077 - 18:30:00'
      expect(page).to have_content 'Concluído'
      expect(page).to have_content '15/05/2077 - 19:00:00'
      expect(page).to have_content 'Entregue'
      expect(page).to have_content '15/05/2077 - 19:20:00'
    end
  end
end