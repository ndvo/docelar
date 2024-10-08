class PharmacotherapiesController < ApplicationController
  before_action :set_pharmacotherapy, only: %i[ show edit update destroy ]

  # GET /pharmacotherapies or /pharmacotherapies.json
  def index
    @pharmacotherapies = Pharmacotherapy.all
  end

  # GET /pharmacotherapies/1 or /pharmacotherapies/1.json
  def show
  end

  # GET /pharmacotherapies/new
  def new
    @pharmacotherapy = Pharmacotherapy.new
  end

  # GET /pharmacotherapies/1/edit
  def edit
  end

  # POST /pharmacotherapies or /pharmacotherapies.json
  def create
    @pharmacotherapy = Pharmacotherapy.new(pharmacotherapy_params)

    respond_to do |format|
      if @pharmacotherapy.save
        format.html { redirect_to pharmacotherapy_url(@pharmacotherapy), notice: "Pharmacotherapy was successfully created." }
        format.json { render :show, status: :created, location: @pharmacotherapy }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pharmacotherapy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pharmacotherapies/1 or /pharmacotherapies/1.json
  def update
    respond_to do |format|
      if @pharmacotherapy.update(pharmacotherapy_params)
        format.html { redirect_to pharmacotherapy_url(@pharmacotherapy), notice: I18n.t('messages.saved') }
        format.json { render :show, status: :ok, location: @pharmacotherapy }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pharmacotherapy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacotherapies/1 or /pharmacotherapies/1.json
  def destroy
    @pharmacotherapy.destroy

    respond_to do |format|
      format.html { redirect_to pharmacotherapies_url, notice: "Pharmacotherapy was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacotherapy
      @pharmacotherapy = Pharmacotherapy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pharmacotherapy_params
      params.require(:pharmacotherapy).permit(:treatment_id, :medication_id, :frequency_value, :frequency_unit, :dosage_value, :dosage_unit, :duration, :end_date)
    end
end
