class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]

  include DateNavigation

  # GET /payments or /payments.json
  def index
    @payments = list_month || []
    @total_paid = @payments.reduce(0) { |acc, cur| acc + (cur.paid_amount || 0) }
    @total_due = @payments.reduce(0) { |acc, cur| acc + (cur.due_amount || 0) }
  end

  # Public: Payments paid or due this month
  # 
  # Uses the date param to query the database for payments that are either due
  # or paid in the 'date' month.  'date' defaultts to today.
  #
  def list_month
    set_month_navigation
    @list_month ||=
      Payment.paid_at_month(@chosen_month)
      .or(Payment.due_at_month(@chosen_month))
      .or(Payment.late)
      .includes(purchase: :card).order("cards.name")
      .order(due_at: :asc)
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payment_url(@payment), notice:  I18n.t('messages.saved') }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def payments_bulk_update
    checked_payment_ids = params[:payment_ids]

    paid_at = DateTime.now

    list_month.where(id: checked_payment_ids, paid_at: nil).each do |p|
      p.paid_at = DateTime.now
      p.paid_amount = p.due_amount
      p.save
    end
    list_month.where.not(id: checked_payment_ids).each do |p|
      p.paid_at = nil
      p.paid_amount = nil
      p.save
    end

    redirect_to action: :index, notice: 'Pagamentos atualizados com sucesso.' 
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def payment_params
    params.require(:payment).permit(:due_amount, :due_at, :paid_amount, :paid_at, :purchase_id)
  end
end
