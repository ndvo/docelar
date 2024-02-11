class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[show edit update destroy]
  before_action :use_products, only: %i[new edit set_installments]
  before_action :set_products, only: %i[new edit create update]

  # GET /purchases or /purchases.json
  def index
    @purchases = Purchase.month month
  end

  # GET /purchases/1 or /purchases/1.json
  def show; end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
    @purchase.product = Product.new
    @purchase.qty_installments = 1
    @purchase.quantity = 1
    @purchase.purchase_at = DateTime.now.to_date
    @product = Product.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases or /purchases.json
  def create
    product_id = params[:purchase][:product_id]

    product = if product_id.present?
                Product.find(product_id)
              else
                Product.create(product_params)
              end
    @purchase = Purchase.new(purchase_params.merge(product:))
    respond_to do |format|
      if @purchase.save
        format.html { redirect_to purchase_url(@purchase), notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1 or /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to purchase_url(@purchase), notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url, notice: "Purchase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def installments
    @purchase.payments.length
  end

  def installment_month(from_now)
    d = from_now || DateTime.now
    (d + 1.month).to_date
  end

  def installment_value
    (@purchase.price / installments).round(2) if @purchase.price
  end

  helper_method :installments, :installment_month, :installment_value

  private

  def month
    provided_month = query_params[:month]
    return Date.today unless provided_month

    Date.parse(provided_month)
  end

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def purchase_params
    params.require(:purchase)
      .permit(
        :add_payment,
        :price,
        :purchase_at,
        :qty_installments,
        :quantity,
        payments_attributes: %i[purchase_id due_amount due_at _destroy])
  end

  def product_params
    params.require(:purchase).permit(product: %i[name description brand kind])[:product]
  end

  def query_params
    params.permit(:from, :to, :month, :day, :month_relative)
  end

  def use_products
    @products = Product.all
  end

  def set_products
    @products = Product.all
  end
end
