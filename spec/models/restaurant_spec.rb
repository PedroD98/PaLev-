require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando Razão Social está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: '', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '2128970790', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :legal_name).to be true
      end

      it 'falso quando Nome Fantasia está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: '',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '2128970790', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :restaurant_name).to be true
      end

      it 'falso quando CNPJ está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '', email: 'mcronald@email.com',
                                    phone_number: '2128970790', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :registration_number).to be true
      end

      it 'falso quando E-mail está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: '',
                                    phone_number: '2128970790', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :email).to be true
      end

      it 'falso quando Telefone está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :phone_number).to be true
      end

      it 'falso quando Endereço está vazio' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '2128970790', address: '', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :address).to be true
      end

      it 'código aleatório é gerado' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                              email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '2127670790', address: 'Av Mario, 30', user: user)
  
        expect(restaurant.code.length).to be_present
        expect(restaurant.code.length).to eq 6
      end
    end

    context 'uniqueness' do
      it 'falso quando Razão Social já está em uso' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13',
                            email: 'pedro@email.com', password: 'passwordpass')
        other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                            email: 'kariny@email.com', password: 'passwordpass')

        Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: user)
        other_restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)


        expect(other_restaurant).not_to be_valid
        expect(other_restaurant.errors.include? :legal_name).to be true
      end

      it 'falso quando CNPJ já está em uso' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                            email: 'kariny@gmail.com', password: 'passwordpass')

        Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: user)
        other_restaurant = Restaurant.new(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '41.684.415/0001-09', email: 'contato@pizzaking.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)


        expect(other_restaurant).not_to be_valid
        expect(other_restaurant.errors.include? :registration_number).to be true
      end

      it 'falso quando Telefone já está em uso' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                            email: 'kariny@gmail.com', password: 'passwordpass')

        Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: user)
        other_restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'contato@pizzaking.com',
                                    phone_number: '2128970790', address: 'Av Luigi, 30', user: other_user)


        expect(other_restaurant).not_to be_valid
        expect(other_restaurant.errors.include? :phone_number).to be true
      end

      it 'falso quando E-mail já está em uso' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        other_user = User.create!(name: 'Kariny', surname: 'Fonseca', social_number: '621.271.587-41',
                            email: 'kariny@gmail.com', password: 'passwordpass')

        Restaurant.create!(legal_name: 'Rede Pizza King LTDA', restaurant_name: 'McRonald',
                       registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                       phone_number: '2128970790', address: 'Av Mario, 30', user: user)
        other_restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'Pizza King',
                                    registration_number: '56.281.566/0001-93', email: 'mcronald@email.com',
                                    phone_number: '2127670444', address: 'Av Luigi, 30', user: other_user)


        expect(other_restaurant).not_to be_valid
        expect(other_restaurant.errors.include? :email).to be true
      end

      it 'código é único' do
        user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                              email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.create!(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '2127670790', address: 'Av Mario, 30', user: user)
  
        expect(restaurant.code.length).to be_present
        expect(restaurant.code.length).to eq 6
      end
    end

    it 'falso quando CNPJ for inválido' do
      user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
      restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                  registration_number: '59.541.264/0000-00', email: 'mcronald@email.com',
                                  phone_number: '2128970790', address: 'Av Mario, 30', user: user)

      expect(restaurant).not_to be_valid
      expect(restaurant.errors.include? :registration_number).to be true
    end

    it 'falso quando Telefone for inválido' do
      user = User.create!(name: 'Pedro', surname: 'Dias', social_number: '637.971.725-08',
                            email: 'pedro@email.com', password: 'passwordpass')
        restaurant = Restaurant.new(legal_name: 'Rede McRonald LTDA', restaurant_name: 'McRonald',
                                    registration_number: '41.684.415/0001-09', email: 'mcronald@email.com',
                                    phone_number: '212-7670790', address: 'Av Mario, 30', user: user)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors.include? :phone_number).to be true
    end
  end
end
