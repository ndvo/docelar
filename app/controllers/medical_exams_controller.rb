class MedicalExamsController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_exam, only: [:show, :edit, :update, :destroy]

  def index
    @exams = @patient.medical_exams.order(exam_date: :desc)
  end

  def show
    @patient = @exam.patient
  end

  def new
    @exam = @patient.medical_exams.build
  end

  def create
    @exam = @patient.medical_exams.build(exam_params)
    
    if @exam.save
      redirect_to patient_medical_exam_path(@patient, @exam), notice: 'Exame registrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient = @exam.patient
  end

  def update
    if @exam.update(exam_params)
      redirect_to patient_medical_exam_path(@exam.patient, @exam), notice: 'Exame atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exam.destroy
    redirect_to patient_medical_exams_path(@exam.patient), notice: 'Exame removido.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_exam
    @exam = MedicalExam.find(params[:id])
  end

  def exam_params
    params.require(:medical_exam).permit(
      :exam_date,
      :exam_type,
      :name,
      :laboratory,
      :location,
      :results_summary,
      :interpretation,
      :status,
      :medical_appointment_id
    )
  end
end
