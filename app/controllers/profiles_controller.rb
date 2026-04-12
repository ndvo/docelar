class ProfilesController < ApplicationController
  before_action :require_authentication

  def show
    @user = Current.user
  end

  def password
    @user = Current.user
    if @user.authenticate(params.dig(:user, :current_password).to_s)
      if @user.update(password_update_params)
        redirect_to profile_path, notice: I18n.t('messages.saved')
      else
        render :show, status: :unprocessable_entity
      end
    else
      @user.errors.add(:current_password, 'is incorrect')
      flash[:alert] = 'Current password is incorrect'
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user = Current.user
    if @user.authenticate(params.dig(:user, :current_password).to_s)
      @user.destroy
      @user.sessions.destroy_all
      cookies.delete(:session_id)
      redirect_to root_path, notice: 'Account deleted successfully.'
    else
      redirect_to profile_path, alert: 'Incorrect password. Account not deleted.'
    end
  end

  private

  def password_update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
