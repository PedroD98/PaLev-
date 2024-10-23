require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'false quando Nome está vazio' do
        user = User.new(name: '', surname: 'Dias', social_number: '145.382.206-20', 
                        email: 'pedro@gmail.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
      
      it 'false quando Sobrenome está vazio' do
        user = User.new(name: 'Pedro', surname: '', social_number: '145.382.206-20', 
                        email: 'pedro@gmail.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
      
      it 'false quando CPF está vazio' do
        user = User.new(name: 'Pedro', surname: 'Dias', social_number: '', 
                        email: 'pedro@gmail.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
    end

    it 'falso quando o CPF é inválido' do
      user = User.new(name: 'Pedro', surname: 'Dias', social_number: '123.456.789-09', 
                      email: 'pedro@gmail.com', password: 'passwordpass')

      expect(user).not_to be_valid
    end

    it 'falso quando a senha é muito curta' do
      user = User.new(name: 'Pedro', surname: 'Dias', social_number: '145.382.206-20', 
                      email: 'pedro@gmail.com', password: 'password')

      expect(user).to be_valid
    end
  end
end
