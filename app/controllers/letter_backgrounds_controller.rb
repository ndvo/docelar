require "mini_magick"

class LetterBackgroundsController < ApplicationController
  before_action :require_authentication
  before_action :set_letter_background, only: [:show, :edit, :update, :destroy, :add_filter, :remove_filter, :undo_filter, :redo_filter, :reset_filters, :preview, :apply_preset, :list_presets]

  def index
    @letter_backgrounds = Current.user.letter_backgrounds.order(created_at: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: filter_response }
    end
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

  def add_filter
    filter_type = params[:filter_type]
    filter_params = params.fetch(:filter_params, {})
    filter_params = filter_params.with_indifferent_access if filter_params.respond_to?(:with_indifferent_access)

    @letter_background.add_filter(filter_type, filter_params)
    @letter_background.save

    render json: filter_response
  end

  def remove_filter
    filter_id = params[:filter_id]
    return render(json: { error: "Filter ID required" }, status: :bad_request) if filter_id.blank?
    
    @letter_background.remove_filter(filter_id)
    @letter_background.save

    render json: filter_response
  end

  def undo_filter
    @letter_background.undo_filter
    @letter_background.save

    render json: filter_response
  end

  def redo_filter
    @letter_background.redo_filter
    @letter_background.save

    render json: filter_response
  end

  def reset_filters
    @letter_background.reset_filters
    @letter_background.save

    render json: filter_response
  end

  def apply_preset
    preset_name = params[:preset_name]
    filters = ImageFilterService.apply_preset(preset_name)
    
    if filters.nil?
      return render(json: { error: "Preset inválido" }, status: :bad_request)
    end

    filters.each do |filter|
      @letter_background.add_filter(filter[:type], filter[:params] || {})
    end
    @letter_background.save

    render json: filter_response
  end

  def list_presets
    render json: {
      presets: ImageFilterService.presets.map do |name, filters|
        { name: name, label: ImageFilterService.preset_labels[name], filters: filters }
      end
    }
  end

def preview
    return head :not_found unless @letter_background.image.attached?

    blob = @letter_background.image.blob
    file_path = ActiveStorage::Blob.service.path_for(blob.key)

    begin
      image = MiniMagick::Image.open(file_path)
      filters = @letter_background.reload.filters
      Rails.logger.info "PREVIEW: letter_background_id=#{@letter_background.id}, filters=#filters.inspect}"
      result = ImageFilterService.apply_filters(image, filters)

      output_path = "/tmp/letter_bg_#{@letter_background.id}_#{Time.current.to_i}.png"
      result.write(output_path)

      response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "0"
      send_file output_path, type: "image/png", disposition: "inline"
    rescue => e
      Rails.logger.error "Preview error: #{e.message}"
      head :unprocessable_entity
    end
  end

  private

  def set_letter_background
    @letter_background = Current.user.letter_backgrounds.find(params[:id])
  end

  def filter_response
    {
      filters: @letter_background.filters,
      redo_stack: @letter_background.redo_stack,
      can_undo: @letter_background.can_undo?,
      can_redo: @letter_background.can_redo?
    }
  end

  def letter_background_params
    params.require(:letter_background).permit(:name, :source_type, :photo_id, :image, :active)
  end
end