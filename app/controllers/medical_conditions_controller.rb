class MedicalConditionsController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_condition, only: [:show, :edit, :update, :destroy]

  def index
    @conditions = @patient.medical_conditions.order(diagnosed_date: :desc)
  end

  def show
    @patient = @condition.patient
  end

  def new
    @condition = @patient.medical_conditions.build
  end

  def create
    @condition = @patient.medical_conditions.build(condition_params)
    
    if @condition.save
      redirect_to patient_medical_condition_path(@patient, @condition), notice: 'Condição registrada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient = @condition.patient
  end

  def update
    if @condition.update(condition_params)
      redirect_to patient_medical_condition_path(@condition.patient, @condition), notice: 'Condição atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @condition.destroy
    redirect_to patient_medical_conditions_path(@condition.patient), notice: 'Condição removida.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_condition
    @condition = MedicalCondition.find(params[:id])
  end

  def condition_params
    params.require(:medical_condition).permit(
      :condition_name,
      :icd_code,
      :diagnosed_date,
      :status,
      :severity,
      :notes,
      :resolved_date
    )
  end
end
