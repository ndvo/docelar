require 'rails_helper'

RSpec.describe 'Treatment Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'treatment list' do
    scenario 'shows all treatments' do
      person = create(:person, name: 'Maria')
      patient = Patient.find_or_create_by!(individual: person)
      create(:treatment, patient: patient, name: 'Infection Treatment', start_date: Date.today)

      visit treatments_path
      expect(page).to have_content('Infection Treatment')
    end
  end

  describe 'new treatment form' do
    scenario 'shows patient selection' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      visit new_patient_treatment_path(patient)
      expect(page).to have_content('Nome do Tratamento')
    end

    scenario 'creates treatment without medications' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)

      visit new_patient_treatment_path(patient)
      fill_in 'treatment[name]', with: 'Physical Therapy'
      fill_in 'treatment[start_date]', with: Date.today.iso8601

      click_button 'Salvar'

      expect(page).to have_current_path(/\/treatments\/\d+/)
      expect(Treatment.last.name).to eq('Physical Therapy')
      expect(Treatment.last.pharmacotherapies).to be_empty
    end

    scenario 'creates treatment with pharmacotherapy' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      medication = create(:medication, name: 'Antibiotic')

      visit new_patient_treatment_path(patient)
      fill_in 'treatment[name]', with: 'Infection Treatment'
      fill_in 'treatment[start_date]', with: Date.today.iso8601

      click_on '+ Adicionar medicamento'
      select 'Antibiotic', from: 'treatment[pharmacotherapies_attributes][0][medication_id]'
      fill_in 'treatment[pharmacotherapies_attributes][0][dosage]', with: '500mg'

      click_button 'Salvar'

      expect(Treatment.last.name).to eq('Infection Treatment')
      expect(Treatment.last.pharmacotherapies.count).to eq(1)
      expect(Treatment.last.pharmacotherapies.first.medication.name).to eq('Antibiotic')
    end
  end

  describe 'edit treatment' do
    scenario 'displays existing treatment form' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, name: 'Test Treatment', start_date: Date.today)
      medication = create(:medication, name: 'Aspirin')
      create(:pharmacotherapy, treatment: treatment, medication: medication, dosage: '100mg')

      visit edit_treatment_path(treatment)

      expect(page).to have_content('Medicamentos')
      expect(page).to have_select('treatment[pharmacotherapies_attributes][0][medication_id]', selected: 'Aspirin')
    end

    scenario 'adds new medication to existing treatment', skip: 'Requires JavaScript driver (Selenium/Headless Chrome)' do
      person = create(:person)
      patient = Patient.find_or_create_by!(individual: person)
      treatment = create(:treatment, patient: patient, name: 'Existing Treatment', start_date: Date.today)
      medication = create(:medication, name: 'NewMed')

      visit edit_treatment_path(treatment)
      
      click_on '+ Adicionar medicamento'
      
      select 'NewMed', from: 'treatment[pharmacotherapies_attributes][0][medication_id]'
      fill_in 'treatment[pharmacotherapies_attributes][0][dosage]', with: '25mg'
      
      click_button 'Salvar'
      
      treatment.reload
      expect(treatment.pharmacotherapies.count).to eq(1)
      expect(treatment.pharmacotherapies.first.medication.name).to eq('NewMed')
    end
  end
end
