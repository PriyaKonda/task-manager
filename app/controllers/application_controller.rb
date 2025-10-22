class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?

  protected

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  rescue Mongoid::Errors::DocumentNotFound
    session.delete(:user_id)
    nil
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      store_location
      redirect_to login_path, alert: "Please log in to access this page"
    end
  end

  def authenticate_user!
    unless current_user
      store_location
      redirect_to login_path, alert: "Authentication required. Please log in to continue."
    end
  end

  def store_location
    session[:return_to] = request.original_url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end
