class Video::CommentsController < ApplicationController
  before_action :set_video

  def create
    @comment = @video.comments.build(comment_params)
    @comment.user = current_user if defined?(current_user) && current_user
    
    if @comment.save
      redirect_to @video, notice: 'Comentário adicionado.'
    else
      redirect_to @video, alert: 'Erro ao salvar comentário.'
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def comment_params
    params.require(:video_comment).permit(:content, :timestamp_seconds)
  end
end