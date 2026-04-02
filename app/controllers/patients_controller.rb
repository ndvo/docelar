class PatientsController < ApplicationController
  before_action :set_patient, only: %i[ show edit update destroy medications ]

  # GET /patients or /patients.json
  def index
    @patient_type = params[:type] || 'Person'
    @patients = Patient.where(individual_type: @patient_type).order(created_at: :desc)
    @active_treatments_count = Treatment.active.count
    @today_doses_count = MedicationAdministration.where("DATE(scheduled_at) = ?", Date.today).count
  end

  # GET /medications/dashboard
  def dashboard
    @patient_type = 'Person'
    @patients = Patient.where(individual_type: @patient_type).order(created_at: :desc)
    @active_treatments_count = Treatment.active.count
    @today_doses_count = MedicationAdministration.where("DATE(scheduled_at) = ?", Date.today).count
    
    @next_admin = MedicationAdministration.where("DATE(scheduled_at) = ?", Date.today)
      .where("scheduled_at > ?", Time.current)
      .order(:scheduled_at).first
    @next_dose = @next_admin&.scheduled_at
    @next_dose_medication = @next_admin&.medication&.name
  end

  # GET /patients/1/medications
  def medications
  end

  # GET /patients/1 or /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient_type = params[:type] || 'Dog'
    existing_ids = Patient.where(individual_type: @patient_type).pluck(:individual_id)
    
    @individuals = case @patient_type
                   when 'Person' then Person.where.not(id: existing_ids)
                   when 'Dog' then Dog.where.not(id: existing_ids)
                   else []
                   end
    @patient = Patient.new(individual_type: @patient_type)
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients or /patients.json
  def create
    individual_type = patient_params[:individual_type] || 'Dog'
    individual_class = individual_type.constantize
    
    individual_id = patient_params[:individual_id] || params.dig(:patient, :individual_id)
    @individual = individual_class.find(individual_id)
    @patient = Patient.new(individual: @individual)
    
    respond_to do |format|
      if @patient.save
        format.html { redirect_to patient_url(@patient), notice: "Patient was successfully created." }
        format.json { render :show, status: :created, location: @patient }
      else
        @individuals = case individual_type
                       when 'Person' then Person.all
                       when 'Dog' then Dog.all
                       else []
                       end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to patient_url(@patient), notice: I18n.t('messages.saved') }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1 or /patients/1.json
  def destroy
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url, notice: "Patient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def patient_params
      params.require(:patient).permit(:individual_id, :individual_type)
    end
end
