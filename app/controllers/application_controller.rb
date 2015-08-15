class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_login

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  helper_method :current_user

  private
    def check_login
      if current_user.blank?
        session[:original_action] = { controller: controller_name, action: action_name }
        session[:original_action][:id] = params[:id] if params.present? && params.has_key?(:id)
        redirect_to controller: 'logins', action: 'new'
      else
        session[:original_action] = nil
      end
    end
end
