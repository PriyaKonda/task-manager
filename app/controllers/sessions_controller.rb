class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]
  before_action :require_login, only: [:destroy]

  def new
  end

  def create
    user = User.where(email: params[:email]&.downcase&.strip).first
    
    if user&.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id.to_s
      flash[:notice] = "Welcome, #{user.name}!"
      redirect_to(session.delete(:return_to) || tasks_path)
    else
      flash.now[:alert] = if params[:email].blank? || params[:password].blank?
        "Email and password are required"
      elsif !user
        "No account found with this email address"
      else
        "Incorrect password"
      end
      render :new, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("Login error: #{e.message}\n#{e.backtrace.join("\n")}")
    flash.now[:error] = "An unexpected error occurred. Please try again later."
    render :new, status: :unprocessable_entity
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_path, notice: "You have been logged out successfully!"
  end

  private

  def redirect_if_authenticated
    if logged_in?
      redirect_to tasks_path, notice: "You are already logged in."
    end
  end
end
