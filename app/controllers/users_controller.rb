class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.email = @user.email.downcase.strip

    logger.info("User created #{@user.email}")

    if @user.save
      logger.info("user saved")
      redirect_to login_path, notice: 'Account created successfully! Please log in.'
    else
      render :new, status: :unprocessable_entity
    end
  rescue Mongoid::Errors::Validations => e
    @user.errors.add(:base, e.message)
    render :new, status: :unprocessable_entity
  rescue => e
    @user.errors.add(:base, "An unexpected error occurred. Please try again.")
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_if_authenticated
    if logged_in?
      redirect_to tasks_path, notice: "You are already logged in."
    end
  end
end
