class GreetingCardsController < ApplicationController
  before_action :require_authentication
  before_action :set_greeting_card, only: [:edit, :update, :destroy, :mark_sent]

  def index
    @greeting_cards = Current.user.greeting_cards.order(created_at: :desc)
    @upcoming_cards = Current.user.greeting_cards.upcoming
    @pending_cards = Current.user.greeting_cards.pending
  end

  def new
    @greeting_card = GreetingCard.new
    @greeting_card.occasion_date = 1.month.from_now.to_date if params[:card_type].present?
  end

  def create
    @greeting_card = Current.user.greeting_cards.new(greeting_card_params)
    
    if params[:new_person_name].present?
      person = Person.find_or_create_by!(name: params[:new_person_name])
      @greeting_card.person_id = person.id
    end
    
    if @greeting_card.save
      redirect_to greeting_cards_path, notice: 'Cartão criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @greeting_card.assign_attributes(greeting_card_params)
    
    if params[:new_person_name].present?
      person = Person.find_or_create_by!(name: params[:new_person_name])
      @greeting_card.person_id = person.id
    end
    
    if @greeting_card.save
      redirect_to greeting_cards_path, notice: 'Cartão atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @greeting_card.destroy
    redirect_to greeting_cards_path, notice: 'Cartão removido com sucesso.'
  end

  def mark_sent
    @greeting_card.mark_as_sent
    redirect_to greeting_cards_path, notice: 'Cartão marcado como enviado.'
  end

  private

  def set_greeting_card
    @greeting_card = Current.user.greeting_cards.find(params[:id])
  end

  def greeting_card_params
    params.require(:greeting_card).permit(:title, :message, :person_id, :card_type, :occasion_date, :occasion_type, :letter_background_id)
  end
end