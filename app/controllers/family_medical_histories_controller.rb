class FamilyMedicalHistoriesController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_history, only: [:show, :edit, :update, :destroy]

  def index
    @family_histories = @patient.family_medical_histories.order(diagnosed_relative_date: :desc)
  end

  def show
    @patient = @history.patient
  end

  def new
    @history = @patient.family_medical_histories.build
  end

  def create
    @history = @patient.family_medical_histories.build(history_params)
    
    if @history.save
      redirect_to patient_family_medical_history_path(@patient, @history), notice: 'Histórico familiar registrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient = @history.patient
  end

  def update
    if @history.update(history_params)
      redirect_to patient_family_medical_history_path(@history.patient, @history), notice: 'Histórico familiar atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @history.destroy
    redirect_to patient_family_medical_histories_path(@history.patient), notice: 'Histórico familiar removido.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_history
    @history = FamilyMedicalHistory.find(params[:id])
  end

  def history_params
    params.require(:family_medical_history).permit(
      :relation,
      :condition_name,
      :icd_code,
      :diagnosed_relative_date,
      :notes,
      :age_at_diagnosis
    )
  end
end
