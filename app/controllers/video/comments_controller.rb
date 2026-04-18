class Video::CommentsController < ApplicationController
  before_action :set_video

  def create
    @comment = @video.comments.build(comment_params)
    @comment.user = current_user if defined?(current_user) && current_user.present?
    
    if @comment.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comments-section-content", partial: "videos/comments_section", locals: { video: @video, comments: @video.comments.order(created_at: :desc) }) }
        format.html { redirect_to @video, notice: 'Comentário adicionado.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comments-section-content", partial: "videos/comments_section", locals: { video: @video, comments: @video.comments.order(created_at: :desc) }) }
        format.html { redirect_to @video, alert: 'Erro ao salvar comentário.' }
      end
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def comment_params
    params.require(:video_comment).permit(:content)
  end
end