class MedicationRemindersController < ApplicationController
  before_action :set_reminder, only: %i[show update destroy]

  def show
    render json: @reminder
  end

  def update
    case reminder_params[:action]
    when 'acknowledge'
      @reminder.acknowledge
    when 'snooze'
      minutes = reminder_params[:minutes].to_i
      @reminder.snooze(minutes: minutes)
    end

    render json: @reminder
  end

  def destroy
    @reminder.destroy
    head :no_content
  end

  private

  def set_reminder
    @reminder = MedicationReminder.find_by(id: params[:id])
    head :not_found unless @reminder
  end

  def reminder_params
    params.require(:reminder).permit(:action, :minutes)
  end
end