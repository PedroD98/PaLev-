require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê o nome da app' do
    visit root_path

    expect(page).to have_content 'PaLevá'
  end

  it 'e é redirecionado para a tela de login' do
    visit root_path

    expect(current_path).to eq root_path
  end
end