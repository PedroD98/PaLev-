require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'false quando Nome está vazio' do
        user = User.new(name: '', surname: 'Dias', social_number: '133.976.443-13', 
                        email: 'pedro@email.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
      
      it 'false quando Sobrenome está vazio' do
        user = User.new(name: 'Pedro', surname: '', social_number: '133.976.443-13', 
                        email: 'pedro@email.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
      
      it 'false quando CPF está vazio' do
        user = User.new(name: 'Pedro', surname: 'Dias', social_number: '', 
                        email: 'pedro@email.com', password: 'passwordpass')

        expect(user).not_to be_valid
      end
    end

    it 'falso quando o CPF é inválido' do
      user = User.new(name: 'Pedro', surname: 'Dias', social_number: '123.456.789-09', 
                      email: 'pedro@email.com', password: 'passwordpass')

      expect(user).not_to be_valid
    end

    it 'falso quando CPF já foi cadastrado' do
      User.create!(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', 
      email: 'pedro@email.com', password: 'passwordpass')
      other_user = User.new(name: 'Kariny', surname: 'Fonseca', social_number: '133.976.443-13', 
      email: 'kariny@gmail.com', password: 'passwordwords')
      
      expect(other_user).not_to be_valid
    end

    it 'falso quando a senha é muito curta' do
      user = User.new(name: 'Pedro', surname: 'Dias', social_number: '133.976.443-13', 
                      email: 'pedro@email.com', password: 'password')

      expect(user).not_to be_valid
    end
  end
end
