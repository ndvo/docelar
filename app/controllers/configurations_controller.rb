class ConfigurationsController < ApplicationController
  before_action :require_authentication

  def show
    @appointment_types = AppointmentType.order(:name)
    @new_appointment_type = AppointmentType.new
    @fonts = Font.order(created_at: :desc)
    @new_font = Font.new
  end

  def create_appointment_type
    @new_appointment_type = AppointmentType.new(appointment_type_params)
    if @new_appointment_type.save
      redirect_to configuration_path, notice: 'Tipo de consulta criado com sucesso.'
    else
      @appointment_types = AppointmentType.order(:name)
      render :show
    end
  end

  def update_appointment_types
    @appointment_type = AppointmentType.find(params[:id])
    if @appointment_type.update(appointment_type_params)
      redirect_to configuration_path, notice: 'Tipo de consulta atualizado com sucesso.'
    else
      @appointment_types = AppointmentType.order(:name)
      render :show
    end
  end

  def create_font
    @new_font = Font.new(font_params)
    if @new_font.save
      redirect_to configuration_path, notice: 'Fonte criada com sucesso.'
    else
      @appointment_types = AppointmentType.order(:name)
      @fonts = Font.order(created_at: :desc)
      render :show
    end
  end

  def update_pomodoro_goal
    if current_user.update(pomodoro_goal_params)
      redirect_to configuration_path, notice: 'Meta Pomodoro atualizada com sucesso.'
    else
      @appointment_types = AppointmentType.order(:name)
      @new_appointment_type = AppointmentType.new
      @fonts = Font.order(created_at: :desc)
      @new_font = Font.new
      flash.now[:alert] = current_user.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  def destroy_font
    @font = Font.find(params[:id])
    @font.destroy
    redirect_to configuration_path, notice: 'Fonte removida com sucesso.'
  end

  private

  def appointment_type_params
    params.require(:appointment_type).permit(:name, :description, :applicable_types, :active)
  end

  def font_params
    params.require(:font).permit(:name, :description, :file, :active, occasions: [])
  end

  def pomodoro_goal_params
    params.require(:user).permit(:daily_pomodoro_goal)
  end
end