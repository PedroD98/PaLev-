# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.create(name: 'Pedro', surname: 'Dias', social_number: '712.220.116-38',
                    email: 'pedro@campuscode.com', password: 'passwordpass', registered_restaurant: true)

restaurant = Restaurant.create!(legal_name: 'Rede Campus Lanches LTDA', restaurant_name: 'Campus Lanches',
                                registration_number: '12.385.390/0001-44', email: 'contato@campuslanches.com',
                                phone_number: '2327670444', address: 'Av Luigi, 30', user: admin, code: 'C4MPU5')

OperatingHour.create!(day_of_week: 0, closed: true, restaurant: restaurant)

6.times do |index|
  OperatingHour.create!(day_of_week: index + 1, open_time: Time.zone.parse('06:00 AM'),
                          close_time: Time.zone.parse('11:59 PM'), restaurant: restaurant)
end

manager = Position.create!(restaurant: restaurant, description: 'Gerente')
cook = Position.create!(restaurant: restaurant, description: 'Cozinheiro')
server = Position.create!(restaurant: restaurant, description: 'Garçom')

PreRegister.create!(restaurant: restaurant, user: admin, position: manager, active: true,
                    employee_social_number: '281.830.956-58', employee_email: 'erika@campuscode.com')
PreRegister.create!(restaurant: restaurant, user: admin, position: cook,
                    employee_social_number: '202.578.920-36', employee_email: 'claudia@campuscode.com')
PreRegister.create!(restaurant: restaurant, user: admin, position: cook,
                    employee_social_number: '760.418.081-72', employee_email: 'joao@campuscode.com')
PreRegister.create!(restaurant: restaurant, user: admin, position: server,
                    employee_social_number: '229.387.033-25', employee_email: 'andre@campuscode.com')

Employee.create!(name: 'Erika', surname: 'Silva', social_number: '281.830.956-58', is_owner: false,
                 email: 'erika@campuscode.com', password: 'passwordpass', restaurant: restaurant,
                 registered_restaurant: true)


vegan = Tag.create!(restaurant: restaurant, name: 'Vegano')
spicy = Tag.create!(restaurant: restaurant, name: 'Apimentado')
sweet = Tag.create!(restaurant: restaurant, name: 'Alto teor de açúcar')

quibe = Dish.create!(restaurant: restaurant, name: 'Quibe', calories: 100, 
                     description: 'Quibe fresco feito na casa', tags: [spicy])

quibe_1 = Portion.create!(item: quibe, description: '1 unid.', price: 7)
quibe_3 = Portion.create!(item: quibe, description: '3 unid.', price: 18.50)

PriceHistory.create!(restaurant: restaurant, item_id: quibe.id, portion_id: quibe_1.id,
                     price: quibe_1.price, insertion_date: I18n.l(Date.today),
                     description: "#{quibe.name} - #{quibe_1.description}")
PriceHistory.create!(restaurant: restaurant, item_id: quibe.id, portion_id: quibe_3.id,
                     price: quibe_3.price, insertion_date: I18n.l(Date.today),
                     description: "#{quibe.name} - #{quibe_3.description}")

vegan_burguer =  Dish.create!(restaurant: restaurant, name: 'Hambúrguer de Soja', calories: 230,
                              description: 'Hambúrguer feito com soja de produtores locais', tags: [vegan])

burguer_portion = Portion.create!(item: vegan_burguer, description: 'Individual', price: 14.90)

PriceHistory.create!(restaurant: restaurant, item_id: vegan_burguer.id, portion_id: burguer_portion.id,
                     price: burguer_portion.price, insertion_date: I18n.l(Date.today),
                     description: "#{vegan_burguer.name} - #{burguer_portion.description}")

coxinha = Dish.create!(restaurant: restaurant, name: 'Coxinha', calories: 342,
                       description: 'Coxinha de frango')

coxinha_1 = Portion.create!(item: coxinha, description: '1 unid.', price: 5)
coxinha_3 = Portion.create!(item: coxinha, description: '3 unid.', price: 14.80)
coxinha_7 = Portion.create!(item: coxinha, description: '7 unid.', price: 33)

PriceHistory.create!(restaurant: restaurant, item_id: coxinha.id, portion_id: coxinha_1.id,
                     price: coxinha_1.price, insertion_date: I18n.l(Date.today),
                     description: "#{coxinha.name} - #{coxinha_1.description}")
PriceHistory.create!(restaurant: restaurant, item_id: coxinha.id, portion_id: coxinha_3.id,
                     price: coxinha_3.price, insertion_date: I18n.l(Date.today),
                     description: "#{coxinha.name} - #{coxinha_3.description}")
PriceHistory.create!(restaurant: restaurant, item_id: coxinha.id, portion_id: coxinha_7.id,
                     price: coxinha_7.price, insertion_date: I18n.l(Date.today),
                     description: "#{coxinha.name} - #{coxinha_7.description}")


cake =  Dish.create!(restaurant: restaurant, name: 'Bolo de cenoura', calories: 400,
                     description: 'Bolo de vó', tags: [sweet])

cake_individual = Portion.create!(item: cake, description: 'Fatia individual', price: 8.90)
cake_family = Portion.create!(item: cake, description: 'Bolo inteiro', price: 90)

PriceHistory.create!(restaurant: restaurant, item_id: cake.id, portion_id: cake_individual.id,
                     price: cake_individual.price, insertion_date: I18n.l(Date.today),
                     description: "#{cake.name} - #{cake_individual.description}")
PriceHistory.create!(restaurant: restaurant, item_id: cake.id, portion_id: cake_family.id,
                     price: cake_family.price, insertion_date: I18n.l(Date.today),
                     description: "#{cake.name} - #{cake_family.description}")

ice_cream = Dish.create!(restaurant: restaurant, name: 'Sorvete', calories: 328,
                         description: 'Sorvete artesanal de chocolate', tags: [sweet])

ice_cream_1 = Portion.create!(item: ice_cream, description: '1 bola', price: 7.90)
ice_cream_2 = Portion.create!(item: ice_cream, description: '2 bolas', price: 15)
ice_cream_3 = Portion.create!(item: ice_cream, description: '3 bolas', price: 20.80)

PriceHistory.create!(restaurant: restaurant, item_id: ice_cream.id, portion_id: ice_cream_1.id,
                     price: ice_cream_1.price, insertion_date: I18n.l(Date.today),
                     description: "#{ice_cream.name} - #{ice_cream_1.description}")
PriceHistory.create!(restaurant: restaurant, item_id: ice_cream.id, portion_id: ice_cream_2.id,
                     price: ice_cream_2.price, insertion_date: I18n.l(Date.today),
                     description: "#{ice_cream.name} - #{ice_cream_2.description}")
PriceHistory.create!(restaurant: restaurant, item_id: ice_cream.id, portion_id: ice_cream_3.id,
                     price: ice_cream_3.price, insertion_date: I18n.l(Date.today),
                     description: "#{ice_cream.name} - #{ice_cream_3.description}")

coca = Beverage.create!(restaurant: restaurant, name: 'Coca Cola',
                        description: 'Coquinha gelada', calories: 430)

can = Portion.create!(item: coca, description: 'Coca lata', price: 7.30)
bottle = Portion.create!(item: coca, description: 'Garrafa 1,5L', price: 18.90)

PriceHistory.create!(restaurant: restaurant, item_id: coca.id, portion_id: can.id,
                     price: can.price, insertion_date: I18n.l(Date.today),
                     description: "#{coca.name} - #{can.description}")
PriceHistory.create!(restaurant: restaurant, item_id: coca.id, portion_id: bottle.id,
                     price: bottle.price, insertion_date: I18n.l(Date.today),
                     description: "#{coca.name} - #{bottle.description}")

caipirinha = Beverage.create!(restaurant: restaurant, name: 'Caipirinha de Limão',
                              description: 'Brasilidade em forma líquida', calories: 390)

caipi_small = Portion.create!(item: caipirinha, description: 'Copo 400ml', price: 12.90)
caipi_large = Portion.create!(item: caipirinha, description: 'Copo 700ml', price: 18.50)

PriceHistory.create!(restaurant: restaurant, item_id: caipirinha.id, portion_id: caipi_small.id,
                     price: caipi_small.price, insertion_date: I18n.l(Date.today),
                     description: "#{caipirinha.name} - #{caipi_small.description}")
PriceHistory.create!(restaurant: restaurant, item_id: caipirinha.id, portion_id: caipi_large.id,
                     price: caipi_large.price, insertion_date: I18n.l(Date.today),
                     description: "#{caipirinha.name} - #{caipi_large.description}")

beer = Beverage.create!(restaurant: restaurant, name: 'Cerveja', alcoholic: true,
                        description: 'Cerveja gelada', calories: 470)

beer_1 = Portion.create!(item: beer, description: '1 unid.', price: 12.90)
beer_10 = Portion.create!(item: beer, description: 'Balde com 10 unid.', price: 110.80)

PriceHistory.create!(restaurant: restaurant, item_id: beer.id, portion_id: beer_1.id,
                     price: beer_1.price, insertion_date: I18n.l(Date.today),
                     description: "#{beer.name} - #{beer_1.description}")
PriceHistory.create!(restaurant: restaurant, item_id: beer.id, portion_id: beer_10.id,
                     price: beer_10.price, insertion_date: I18n.l(Date.today),
                     description: "#{beer.name} - #{beer_10.description}")

orange_juice = Beverage.create!(restaurant: restaurant, name: 'Suco de Laranja',
                                description: 'Suco natural da fruta')

juice_small = Portion.create!(item: orange_juice, description: 'Copo 400ml', price: 5.50)
juice_large = Portion.create!(item: orange_juice, description: 'Copo 700ml', price: 9.30)

PriceHistory.create!(restaurant: restaurant, item_id: orange_juice.id, portion_id: juice_small.id,
                     price: juice_small.price, insertion_date: I18n.l(Date.today),
                     description: "#{orange_juice.name} - #{juice_small.description}")
PriceHistory.create!(restaurant: restaurant, item_id: orange_juice.id, portion_id: juice_large.id,
                     price: juice_large.price, insertion_date: I18n.l(Date.today),
                     description: "#{orange_juice.name} - #{juice_large.description}")


Menu.create!(restaurant: restaurant, name: 'Finger Food', item_ids: [coxinha.id, quibe.id])
Menu.create!(restaurant: restaurant, name: 'Hambúrguers', item_ids: [vegan_burguer.id])
Menu.create!(restaurant: restaurant, name: 'Sobremesa', item_ids: [cake.id, ice_cream.id])
Menu.create!(restaurant: restaurant, name: 'Alcóolicos', item_ids: [beer.id, caipirinha.id])
Menu.create!(restaurant: restaurant, name: 'Sucos', item_ids: [orange_juice.id])

#  Menu Sazonal válido
Menu.create!(restaurant: restaurant, name: 'Menu Sazonal Válido', item_ids: [vegan_burguer.id, orange_juice.id],
                                   starting_date: Date.today, ending_date: Date.tomorrow)

# Menu Sazonal expirado
Menu.create!(restaurant: restaurant, name: 'Menu vencido', item_ids: [],
                            starting_date: 1.week.ago, ending_date: 5.days.ago)


order_1 = Order.create!(restaurant: restaurant, customer_name: 'Ana', customer_social_number: '203.384.318-10',
                        customer_email: 'ana@gmail.com', customer_phone: '21992843317', status: :delivered)
order_1.update(preparing_timestamp: Time.current + 30.minutes)
order_1.update(done_timestamp: Time.current + 1.hour)
order_1.update(delivered_timestamp: Time.current + 1.hour + 20.minutes)

OrderPortion.create!(order: order_1, portion: burguer_portion, qty: 1, description: 'Molho extra')
OrderPortion.create!(order: order_1, portion: can, qty: 1)

order_2 = Order.create!(restaurant: restaurant, customer_name: 'Kariny', 
                        customer_email: 'kariny@gmail.com', status: :confirming)

OrderPortion.create!(order: order_2, portion: coxinha_3, qty: 1)
OrderPortion.create!(order: order_2, portion: can, qty: 2, description: 'O mais gelada possível')

alcoholics_discount = Discount.create!(restaurant: restaurant, name: 'Promoção alcóolica', discount_amount: 20, 
                                       starting_date: Date.today, ending_date: Date.tomorrow, max_use: 20)
DiscountPortion.create!(discount: alcoholics_discount, portion: beer_1)
DiscountPortion.create!(discount: alcoholics_discount, portion: beer_10)
DiscountPortion.create!(discount: alcoholics_discount, portion: caipi_large)
DiscountPortion.create!(discount: alcoholics_discount, portion: caipi_small)

order_3 = Order.create!(restaurant: restaurant, customer_name: 'Arthur', customer_social_number: '113.575.386-50',
                        customer_email: 'arthur@gmail.com', customer_phone: '11992843317')

OrderPortion.create!(order: order_3, portion: caipi_large, qty: 2, discount: alcoholics_discount)
OrderPortion.create!(order: order_3, portion: beer_1, qty: 3, discount: alcoholics_discount)


Discount.create!(restaurant: restaurant, name: 'Promoção vencida', discount_amount: 15, 
                 starting_date: 2.weeks.ago, ending_date: 1.week.ago, max_use: 10)

burguer_discount = Discount.create!(restaurant: restaurant, name: 'Hambúrguer do dia', discount_amount: 25, 
                                    starting_date: Date.today, ending_date: Date.tomorrow)
DiscountPortion.create!(discount: burguer_discount, portion: burguer_portion)

burguer_order = Order.create!(restaurant: restaurant, customer_name: 'Gleise', customer_social_number: '432.685.933-48',
                                customer_email: 'gleise@gmail.com', customer_phone: '11958843317',
                                total_amount: 120.50, total_discount_amount: 89.42, status: :canceled,
                                cancel_reason: 'Valor do pedido estava incorreto')
OrderPortion.create!(order: burguer_order, portion: burguer_portion, qty: 6, description: 'Sem alface')

DiscountOrder.create!(discount: burguer_discount, order: burguer_order)
