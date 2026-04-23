class LetterBackgroundsController < ApplicationController
  before_action :require_authentication
  before_action :set_letter_background, only: [:edit, :update, :destroy]

  def index
    @letter_backgrounds = Current.user.letter_backgrounds.order(created_at: :desc)
  end

  def new
    @letter_background = LetterBackground.new
  end

  def create
    @letter_background = Current.user.letter_backgrounds.new(letter_background_params)
    
    if @letter_background.save
      redirect_to letter_backgrounds_path, notice: 'Fundo criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @letter_background.update(letter_background_params)
      redirect_to letter_backgrounds_path, notice: 'Fundo atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @letter_background.destroy
    redirect_to letter_backgrounds_path, notice: 'Fundo removido com sucesso.'
  end

  private

  def set_letter_background
    @letter_background = Current.user.letter_backgrounds.find(params[:id])
  end

  def letter_background_params
    params.require(:letter_background).permit(:name, :source_type, :photo_id, :image, :active)
  end
end