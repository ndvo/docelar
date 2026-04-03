require 'rails_helper'

RSpec.describe 'People Page', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'show page' do
    scenario 'shows person details' do
      person = create(:person, name: 'Maria', borned_on: Date.new(1980, 1, 15))
      
      visit person_path(person)
      
      expect(page).to have_content('Maria')
    end

    scenario 'shows Tarefas heading in Portuguese' do
      person = create(:person, name: 'Maria')
      
      visit person_path(person)
      
      expect(page).to have_content('Tarefas')
      expect(page).not_to have_content('Tasks')
    end

    scenario 'shows birth date on show page' do
      person = create(:person, name: 'Maria', borned_on: Date.new(1980, 1, 15))
      
      visit person_path(person)
      
      expect(page).to have_content('15/01/1980')
    end

    scenario 'shows nationalities on show page' do
      country = create(:country, name: 'Brasil')
      person = create(:person, name: 'Maria')
      create(:nationality, person: person, country: country)
      
      visit person_path(person)
      
      expect(page).to have_content('Brasil')
    end
  end

  describe 'index page table' do
    scenario 'uses td for data cells (not th)' do
      create(:person, name: 'Maria')
      
      visit people_path
      
      expect(page).not_to have_selector('tbody th')
    end

    scenario 'shows view link alongside edit' do
      person = create(:person, name: 'Maria')
      
      visit people_path
      
      expect(page).to have_link('Ver', href: person_path(person))
      expect(page).to have_link('Editar', href: edit_person_path(person))
    end
  end

  describe 'form error handling' do
    scenario 'shows validation errors' do
      create(:person, name: 'Maria')
      invalid_person = Person.new(name: '')
      invalid_person.valid?
      
      visit new_person_path
      
      fill_in 'Nome', with: ''
      click_button 'Salvar pessoa'
      
      expect(page).to have_selector('#error_explanation')
    end
  end

  describe 'form navigation' do
    scenario 'has back link on new person form' do
      visit new_person_path
      
      expect(page).to have_link('Voltar', href: people_path)
    end

    scenario 'has back link on edit person form' do
      person = create(:person, name: 'Maria')
      
      visit edit_person_path(person)
      
      expect(page).to have_link('Voltar', href: people_path)
    end
  end

  describe 'form styling' do
    scenario 'form is wrapped in card component' do
      visit new_person_path
      
      expect(page).to have_selector('.card')
    end

    scenario 'required fields are marked with asterisk' do
      visit new_person_path
      
      expect(page).to have_content('Nome *')
    end

    scenario 'radio buttons have proper label associations' do
      visit new_person_path
      
      expect(page).to have_selector('label[for*="how"]')
    end
  end

  describe 'index page features' do
    scenario 'shows person count' do
      create_list(:person, 3)
      
      visit people_path
      
      expect(page).to have_content(/[3-9] pessoas/)
    end

    scenario 'has search field' do
      create(:person, name: 'Maria')
      create(:person, name: 'João')
      
      visit people_path
      
      expect(page).to have_field('Buscar')
    end

    scenario 'filters people by search term' do
      create(:person, name: 'Maria')
      create(:person, name: 'João')
      
      visit people_path
      fill_in 'Buscar', with: 'Maria'
      click_button 'Buscar'
      
      expect(page).to have_content('Maria')
      expect(page).not_to have_content('João')
    end
  end
end
