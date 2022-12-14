class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActionController::HttpAuthentication::Token::ControllerMethods
  add_flash_types :success, :danger, :warning
  before_action :set_locale, :get_notifications
  before_action :config_devise_params, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{head :forbidden, content_type: "text/html"}
      format.html do
        redirect_back fallback_location: new_user_session_path,
                      alert: exception.message
      end
      format.js{head :forbidden, content_type: "text/html"}
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def after_sign_in_path_for resource
    stored_location_for(resource) || resource
  end

  def after_sign_out_path_for resource
    stored_location_for(resource) || new_user_session_path
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def get_users
    @pagy, @users = pagy(User.all, items: Settings.digits.size_of_admin_page)
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]

    return if @user

    flash[:danger] = t ".not_found"
    render "shared/_not_found"
  end

  def get_notifications
    return unless current_user

    @notifications = current_user.notifications.newest
  end

  def config_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: User::ALLOWED_USER_PARAMS)
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: User::ALLOWED_USER_PARAMS)
  end
end
