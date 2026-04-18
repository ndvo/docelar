class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy, :play, :update_position]

  def index
    @categories = VideoCategory.all
    if params[:category].present?
      @videos = Video.by_category(params[:category].to_i).recent
    else
      @videos = Video.recent
    end
  end

  def show
    @comments = @video.comments.order(created_at: :desc)
    @notes = @video.notes.order(timestamp_seconds: :asc)
  end

  def new
    @video = Video.new
    @categories = VideoCategory.all
  end

  def create
    # Handle new category creation
    if params[:new_category_name].present?
      parent_id = params[:new_category_parent_id].presence
      category = VideoCategory.create!(name: params[:new_category_name], parent_id: parent_id)
      params[:video][:video_category_id] = category.id
    end

    @video = Video.new(video_params)
    if @video.save
      redirect_to @video, notice: 'Video was successfully created.'
    else
      @categories = VideoCategory.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = VideoCategory.all
  end

  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      @categories = VideoCategory.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_url, notice: 'Video was successfully deleted.'
  end

  def play
    @video.update(playback_position: params[:position].to_i) if params[:position].present?
    render json: { 
      video: @video, 
      stream_url: @video.is_external ? @video.external_url : nil
    }
  end

  def stream
    if @video.external_url.present? && @video.is_external
      redirect_to @video.external_url and return
    end
    
    if @video.file.attached?
      redirect_to rails_blob_url(@video.file, only_path: true) and return
    end
    
    if @video.file_path.present? && File.exist?(@video.file_path)
      send_file @video.file_path, type: 'video/mp4', disposition: :inline
    else
      Rails.logger.warn "Video #{@video.id} stream failed: no valid source (file: #{@video.file.attached?}, external: #{@video.external_url}, path: #{@video.file_path} exists: #{@video.file_path.present? && File.exist?(@video.file_path)})"
      head :not_found
    end
  end

  def update_position
    @video.update(playback_position: params[:position].to_i)
    render json: { success: true }
  end

  def position
    render json: { position: @video.playback_position || 0 }
  end

  def mark_watched
    @video = Video.find(params[:id])
    @video.update(watched: true, watched_at: Time.current)
    redirect_to @video, notice: 'Video marked as watched.'
  end

  def import
    VideoImportJob.perform_later(params[:folder_path])
    redirect_to videos_url, notice: 'Video import started.'
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :description, :file_path, :external_url, :is_external,
                                   :duration_seconds, :video_format, :resolution, :release_year,
                                   :genre, :plot_summary, :poster_url, :video_category_id, :tag_names, :file)
  end
end