class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      check_remember user
      flash[:success] = t "sessions.new.login_success"
      redirect_by_roler
    else
      flash.now[:danger] = t "sessions.new.login_failt"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def redirect_by_roler
    if current_user.role_admin?
      redirect_to admins_root_url
    else
      redirect_to after_sign_in_path
    end
  end
end
