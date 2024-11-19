require 'rails_helper'

describe 'cliente acessa a página de busca de pedidos' do
  it 'e não precisa estar logado' do
    visit search_orders_path

    expect(current_path).to eq search_orders_path
  end

  it 'e vê detalhes da tela' do
    visit search_orders_path

    expect(page).to have_content 'PaLevá'
    expect(page).to have_content 'Boas-vindas à busca de pedidos'
    expect(page).to have_field 'Código'
    expect(page).to have_button 'Buscar'
  end
end