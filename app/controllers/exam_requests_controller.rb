class ExamRequestsController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_exam_request, only: [:show, :edit, :update, :destroy]

  def index
    @exam_requests = @patient.exam_requests.order(requested_date: :desc)
  end

  def show
    @patient = @exam_request.patient
  end

  def new
    @exam_request = @patient.exam_requests.build
  end

  def create
    @exam_request = @patient.exam_requests.build(exam_request_params)
    
    if @exam_request.save
      redirect_to patient_exam_request_path(@patient, @exam_request), notice: 'Solicitação de exame registrada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient = @exam_request.patient
  end

  def update
    if @exam_request.update(exam_request_params)
      redirect_to patient_exam_request_path(@exam_request.patient, @exam_request), notice: 'Solicitação atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exam_request.destroy
    redirect_to patient_exam_requests_path(@exam_request.patient), notice: 'Solicitação removida.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_exam_request
    @exam_request = ExamRequest.find(params[:id])
  end

  def exam_request_params
    params.require(:exam_request).permit(
      :exam_name,
      :requested_date,
      :scheduled_date,
      :status,
      :notes,
      :medical_appointment_id
    )
  end
end
