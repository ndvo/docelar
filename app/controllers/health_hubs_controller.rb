class HealthHubsController < ApplicationController
  before_action :set_patient

  def show
    @upcoming_appointments = @patient.medical_appointments.upcoming.limit(3)
    @active_conditions = @patient.medical_conditions.active_conditions
    @active_treatments = @patient.treatments.active
    @recent_exams = @patient.medical_exams.order(exam_date: :desc).limit(5)
    @family_history = @patient.family_medical_histories
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end
end
