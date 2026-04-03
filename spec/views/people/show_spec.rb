require 'rails_helper'

RSpec.describe 'people/_show', type: :view do
  let(:person) { create(:person, name: 'Maria') }

  it 'uses h2 for card heading (not h1)' do
    render partial: 'people/show', locals: { person: person }
    
    expect(rendered).not_to include('<h1>Tasks</h3>')
    expect(rendered).to include('<h2')
  end

  it 'heading text is in Portuguese' do
    render partial: 'people/show', locals: { person: person }
    
    expect(rendered).to include('Tarefas')
    expect(rendered).not_to include('Tasks')
  end

  it 'shows Portuguese text for responsible prompt' do
    render partial: 'people/show', locals: { person: person }
    
    expect(rendered).to include('Não pronto para receber tarefas')
    expect(rendered).to include('Tornar responsável')
    expect(rendered).not_to include('Not ready to take tasks')
    expect(rendered).not_to include('Make this person responsible')
  end
end
