class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.success"
      log_in @user
      redirect_to root_url
    else
      flash[:danger] = t "users.failt"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end
end
