require 'rails_helper'

describe 'Usuário cria a conta' do
  it 'com sucesso' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '133.976.443-13'
    fill_in 'E-mail', with: 'pedro@email.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'
    
    expect(page).to have_content 'Você realizou seu registro com sucesso.'
    expect(page).to have_content 'Pedro'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Gerenciar Restaurante'
    expect(page).not_to have_link 'Criar conta'
  end

  it 'e preenche todos os campos' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '14538220620'
    fill_in 'E-mail', with: 'pedro@email.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e digita um CPF inválido' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '123.456.789-09'
    fill_in 'E-mail', with: 'pedro@email.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'
    
    expect(page).not_to have_content 'Você realizou seu registro com sucesso.'
    expect(page).to have_content 'CPF inválido.'
  end
  
  it 'e é redirecionado para o cadastro do restaurante' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Dias'
    fill_in 'CPF', with: '133.976.443-13'
    fill_in 'E-mail', with: 'pedro@email.com'
    fill_in 'Senha', with: 'passwordpass'
    fill_in 'Confirme sua senha', with: 'passwordpass'
    click_on 'Criar conta'

    expect(current_path).to eq new_restaurant_path
  end
end