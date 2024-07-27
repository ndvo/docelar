class CardsController < ApplicationController
  before_action :set_card, only: %i[ destroy edit pay show update ]

  # GET /cards or /cards.json
  def index
    @cards = Card.all
  end

  # GET /cards/1 or /cards/1.json
  def show
    @total_due = @card.payments.due_this_month.pluck(:due_amount).reduce(:+)
    @total_paid = @card.payments.paid.paid_this_month.pluck(:paid_amount).reduce(:+)
    @payments = @card.payments.due_this_month
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards or /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to card_url(@card), notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to card_url(@card), notice: I18n.t('messages.saved') }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url, notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pay
    payments_made = @card.pay_current_month
    respond_to do |format|
      if payments_made.present? && payments_made.all?
        format.html { redirect_to card_url(@card), notice: "Pagamentos registrados" }
        format.json { render :show, status: :ok }
      else
        format.html { redirect_to card_url(@card), notice: "Ocorreu um erro ao salvar" }
        format.json { render json: payments_made.map(&:errors), status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def card_params
      params.require(:card).permit(%i( brand number name expiry_year expiry_month due_day invoice_day))
    end
end
