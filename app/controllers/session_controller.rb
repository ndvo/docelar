class SessionController < ApplicationController
  def new; end

  def create
    user_params
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Seja bem-vindo'
    else
      flash.now.alert = 'Há um erro no email ou na senha.'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Sessão encerrada com sucesso'
  end

  private

  def user_params
    params.require(:email)
    params.require(:password)
  end
end
