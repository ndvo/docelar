class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[show edit update destroy]
  before_action :use_products, only: %i[new edit set_installments]

  # GET /purchases or /purchases.json
  def index
    @purchases = Purchase.all
  end

  # GET /purchases/1 or /purchases/1.json
  def show; end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
    @purchase.product = Product.new
    use_payments
  end

  # GET /purchases/1/edit
  def edit
    use_payments
  end

  # POST /purchases or /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

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

  def set_installments
    @purchase = Purchase.new(purchase_params)
    qty = [params[:purchase][:qty_installments]&.to_i, 1].max
    @purchase.qty_installments = qty
    use_payments
    render :new
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

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def purchase_params
    params.require(:purchase)
          .permit(:price, :product_id, :add_payment, :qty_installments,
                  payments_attributes: %i[purchase_id due_amount due_at _destroy],
                  product_attributes: %i[name description brand kind])
  end

  def use_products
    @products = Product.all
  end

  def use_payments
    (@purchase.qty_installments - installments).times do
      @purchase.payments.build
    end
  end
end
