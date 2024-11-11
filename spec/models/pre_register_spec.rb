require 'rails_helper'

describe '#valid' do
  context 'presence' do
    it 'falso quando CPF ficar em branco' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      position = Position.create!(restaurant: restaurant, description: 'Gerente')
      pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                     employee_social_number: '', employee_email: 'pedro@gmail.com')

      expect(pre_register).not_to be_valid
      expect(pre_register.errors.include? :employee_social_number).to eq true
    end

    it 'falso quando email ficar em branco' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      position = Position.create!(restaurant: restaurant, description: 'Gerente')
      pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                     employee_social_number: '133.976.443-13', employee_email: '')

      expect(pre_register).not_to be_valid
      expect(pre_register.errors.include? :employee_email).to eq true
    end
  end

  context 'uniqueness' do
    it 'falso quando CPF já estiver em uso' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      position = Position.create!(restaurant: restaurant, description: 'Gerente')
      PreRegister.create!(restaurant: restaurant, user: user, position: position,
                          employee_social_number: '133.976.443-13', employee_email: 'pedro@gmail.com')
      other_pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                               employee_social_number: '133.976.443-13', employee_email: 'joao@gmail.com')

      expect(other_pre_register).not_to be_valid
      expect(other_pre_register.errors.include? :employee_social_number).to eq true
    end

    it 'falso quando email já estiver em uso' do
      user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
      restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
      position = Position.create!(restaurant: restaurant, description: 'Gerente')
      PreRegister.create!(restaurant: restaurant, user: user, position: position,
                          employee_social_number: '133.976.443-13', employee_email: 'pedro@gmail.com')
      other_pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                               employee_social_number: '237.547.827-46', employee_email: 'pedro@gmail.com')

      expect(other_pre_register).not_to be_valid
      expect(other_pre_register.errors.include? :employee_email).to eq true
    end
  end

  it 'falso quando CPF é inválido' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Gerente')
    pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                   employee_social_number: '111.222.333-44', employee_email: 'pedro@gmail.com')

    expect(pre_register).not_to be_valid
    expect(pre_register.errors.include? :employee_social_number).to eq true
  end

  it 'falso quando cargo for Dono' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                        email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Dono')
    pre_register = PreRegister.new(restaurant: restaurant, user: user, position: position,
                                   employee_social_number: '133.976.443-13', employee_email: 'pedro@gmail.com')

    expect(pre_register).not_to be_valid
    expect(pre_register.errors.include? :position).to eq true
  end

  it 'status inicial é Não cadastrada' do
    user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                      email: 'kariny@gmail.com', password: 'passwordpass', registered_restaurant: true)
    restaurant = Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                  registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                  phone_number: '2127670444', address: 'Av Luigi, 30', user: user)
    position = Position.create!(restaurant: restaurant, description: 'Gerente')
    pre_register = PreRegister.create!(restaurant: restaurant, user: user, position: position,
                                       employee_social_number: '133.976.443-13', employee_email: 'pedro@gmail.com')

    expect(pre_register.active?).to eq false
  end
end