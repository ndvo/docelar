class Video::NotesController < ApplicationController
  before_action :set_video

  def create
    @note = @video.notes.build(note_params)
    @note.user = current_user if defined?(current_user) && current_user
    
    if @note.save
      redirect_to @video, notice: 'Anotação adicionada.'
    else
      redirect_to @video, alert: 'Erro ao salvar anotação.'
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