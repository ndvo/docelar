class HealthHubsController < ApplicationController
  before_action :set_patient

  def show
    @upcoming_appointments = @patient.medical_appointments.upcoming.limit(3)
    @active_conditions = @patient.medical_conditions.active_conditions
    @active_treatments = @patient.treatments.active.includes(:pharmacotherapies)
    @recent_exams = @patient.medical_exams.order(exam_date: :desc).limit(5)
    @family_history = @patient.family_medical_histories
  end

  def timeline
    @appointments = @patient.medical_appointments.order(appointment_date: :desc).limit(20)
    @conditions = @patient.medical_conditions.order(diagnosed_date: :desc).limit(20)
    @exams = @patient.medical_exams.order(exam_date: :desc).limit(20)
    @treatments = @patient.treatments.order(created_at: :desc).limit(20)
    
    @events = build_timeline_events
    
    respond_to do |format|
      format.html
    end
  end

  private

  def build_timeline_events
    events = []
    
    @appointments.each do |appt|
      events << {
        date: appt.appointment_date,
        type: :appointment,
        title: appt.appointment_type_name.humanize,
        subtitle: appt.professional_name.presence || appt.specialty,
        record: appt
      }
    end
    
    @conditions.each do |cond|
      events << {
        date: cond.diagnosed_date,
        type: :condition,
        title: cond.condition_name,
        subtitle: cond.status.humanize,
        record: cond
      }
    end
    
    @exams.each do |exam|
      events << {
        date: exam.exam_date,
        type: :exam,
        title: exam.name.presence || exam.exam_type.humanize,
        subtitle: exam.status.humanize,
        record: exam
      }
    end
    
    @treatments.each do |treat|
      events << {
        date: treat.created_at,
        type: :treatment,
        title: treat.name,
        subtitle: 'Tratamento prescrito',
        record: treat
      }
    end
    
    events.sort_by { |e| e[:date] }.reverse
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end
end
