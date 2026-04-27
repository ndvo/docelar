require "mini_magick"

class FontsController < ApplicationController
  before_action :require_authentication
  before_action :set_font, only: [:show, :edit, :update, :destroy]

  def index
    @fonts = Font.order(created_at: :desc)
    
    respond_to do |format|
      format.html
      format.json { render json: @fonts.map { |font| {
        id: font.id,
        name: font.name,
        description: font.description,
        occasions: font.occasions,
        preview_url: font.file.attached? ? url_for(font.file) : nil
      } } }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @font }
    end
  end

  def new
    @font = Font.new
  end

  def create
    @font = Font.new(font_params)
    
    if @font.save
      redirect_to fonts_path, notice: 'Fonte criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @font.update(font_params)
      redirect_to fonts_path, notice: 'Fonte atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @font.destroy
    redirect_to fonts_path, notice: 'Fonte removida com sucesso.'
  end

  private

  def set_font
    @font = Font.find(params[:id])
  end

  def font_params
    params.require(:font).permit(:name, :description, :file, :active, occasions: [])
  end
end