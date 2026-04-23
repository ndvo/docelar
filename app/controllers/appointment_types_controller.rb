class AppointmentTypesController < ApplicationController
  before_action :require_authentication
  before_action :set_appointment_type, only: [:toggle_active]

  def toggle_active
    if @appointment_type.update(active: !@appointment_type.active)
      redirect_to configuration_path, notice: 'Status atualizado com sucesso.'
    else
      redirect_to configuration_path, alert: 'Erro ao atualizar status.'
    end
  end

  private

  def set_appointment_type
    @appointment_type = AppointmentType.find(params[:id])
  end
end