class MedicationProductsController < ApplicationController
  before_action :set_medication_product, only: %i[ show edit update destroy ]

  # GET /medication_products or /medication_products.json
  def index
    @medication_products = MedicationProduct.all
  end

  # GET /medication_products/1 or /medication_products/1.json
  def show
  end

  # GET /medication_products/new
  def new
    @medication_product = MedicationProduct.new
  end

  # GET /medication_products/1/edit
  def edit
  end

  # POST /medication_products or /medication_products.json
  def create
    @medication_product = MedicationProduct.new(medication_product_params)

    respond_to do |format|
      if @medication_product.save
        format.html { redirect_to medication_product_url(@medication_product), notice: "Medication product was successfully created." }
        format.json { render :show, status: :created, location: @medication_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medication_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medication_products/1 or /medication_products/1.json
  def update
    respond_to do |format|
      if @medication_product.update(medication_product_params)
        format.html { redirect_to medication_product_url(@medication_product), notice: I18n.t('messages.saved') }
        format.json { render :show, status: :ok, location: @medication_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medication_products/1 or /medication_products/1.json
  def destroy
    @medication_product.destroy

    respond_to do |format|
      format.html { redirect_to medication_products_url, notice: "Medication product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medication_product
      @medication_product = MedicationProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medication_product_params
      params.require(:medication_product).permit(:name, :brand, :form, :per, :per_unit_unit, :picture, :medication_id)
    end
end
