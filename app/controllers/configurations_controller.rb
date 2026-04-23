class ConfigurationsController < ApplicationController
  before_action :require_authentication

  def show
    @appointment_types = AppointmentType.order(:name)
    @new_appointment_type = AppointmentType.new
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

  private

  def appointment_type_params
    params.require(:appointment_type).permit(:name, :description, :applicable_types, :active)
  end
end