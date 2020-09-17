class Admins::BaseController < ApplicationController
  before_action :is_admin?
  layout "admins"

  private

  def is_admin?
    redirect_to root_path unless current_user.role_admin?
  end
end
