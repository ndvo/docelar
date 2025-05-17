class SessionController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @session = false
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      start_new_session_for user
      session[:user_id] = user.id
      redirect_to after_authentication_url, notice: 'Seja bem-vindo'
    else
      redirect_to new_session_path, alert: 'Há um erro no email ou na senha.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Sessão encerrada com sucesso'
  end
end
