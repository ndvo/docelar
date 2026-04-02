class MedicationAdministrationsController < ApplicationController
  before_action :set_administration, only: %i[ show edit update destroy ]

  def update
    respond_to do |format|
      if @administration.update(administration_params)
        format.html { redirect_to patient_url(@administration.pharmacotherapy.treatment.patient), notice: "Administration was successfully updated." }
        format.json { render :show, status: :ok, location: @administration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @administration.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_administration
      @administration = MedicationAdministration.find(params[:id])
    end

    def administration_params
      params.require(:medication_administration).permit(:status, :notes)
    end
end
