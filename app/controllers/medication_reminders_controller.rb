class MedicationRemindersController < ApplicationController
  before_action :set_reminder, only: %i[show update destroy]

  def show
    respond_to do |format|
      format.html
      format.json { render json: @reminder }
    end
  end

  def update
    case reminder_params[:action]
    when 'acknowledge'
      @reminder.acknowledge
    when 'snooze'
      minutes = reminder_params[:minutes].to_i
      @reminder.snooze(minutes: minutes)
    end

    respond_to do |format|
      format.html { redirect_to medication_reminder_path(@reminder), notice: 'Lembrete atualizado.' }
      format.json { render json: @reminder }
    end
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