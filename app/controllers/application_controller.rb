class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :store_location

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::PERMIT_ATTRIBUTES)
    devise_parameter_sanitizer
      .permit(:account_update, keys: User::PERMIT_ATTRIBUTES)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def store_location
    array_path = [new_user_session_path, new_user_registration_path,
      user_password_path, destroy_user_session_path]

    return if array_path.include?(request.fullpath) && !request.xhr?

    session[:user_return_to] = request.fullpath
  end
end
