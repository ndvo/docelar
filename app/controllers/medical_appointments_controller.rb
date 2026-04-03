class MedicalAppointmentsController < ApplicationController
  before_action :set_patient, only: [:index, :new, :create]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index
    @appointments = @patient.medical_appointments.order(appointment_date: :desc)
  end

  def show
    @patient = @appointment.patient
  end

  def new
    @appointment = @patient.medical_appointments.build
  end

  def create
    @appointment = @patient.medical_appointments.build(appointment_params)
    
    if @appointment.save
      redirect_to patient_medical_appointment_path(@patient, @appointment), notice: 'Consulta agendada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient = @appointment.patient
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to patient_medical_appointment_path(@appointment.patient, @appointment), notice: 'Consulta atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    redirect_to patient_medical_appointments_path(@appointment.patient), notice: 'Consulta removida.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_appointment
    @appointment = MedicalAppointment.find(params[:id])
  end

  def appointment_params
    params.require(:medical_appointment).permit(
      :appointment_date,
      :appointment_type,
      :specialty,
      :professional_name,
      :location,
      :reason,
      :notes,
      :status
    )
  end
end
