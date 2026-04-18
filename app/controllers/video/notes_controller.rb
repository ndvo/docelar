class Video::NotesController < ApplicationController
  before_action :set_video

  def create
    @note = @video.notes.build(note_params)
    @note.user = current_user if defined?(current_user) && current_user.present?
    
    if @note.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notes-section-content", partial: "videos/notes_section", locals: { video: @video, notes: @video.notes.order(timestamp_seconds: :asc) }) }
        format.html { redirect_to @video, notice: 'Anotação adicionada.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notes-section-content", partial: "videos/notes_section", locals: { video: @video, notes: @video.notes.order(timestamp_seconds: :asc) }) }
        format.html { redirect_to @video, alert: 'Erro ao salvar anotação.' }
      end
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def note_params
    params.require(:video_note).permit(:content, :timestamp_seconds)
  end
end