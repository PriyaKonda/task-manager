require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create_test_user
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post login_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to tasks_path
    assert_equal "Welcome, #{@user.name}!", flash[:notice]
    assert session[:user_id].present?
  end

  test "should not create session with invalid password" do
    post login_path, params: { email: @user.email, password: "wrongpassword" }
    assert_response :unprocessable_entity
    assert_equal "Incorrect password", flash[:alert]
    assert_nil session[:user_id]
  end

  test "should not create session with invalid email" do
    post login_path, params: { email: "wrong@example.com", password: "password123" }
    assert_response :unprocessable_entity
    assert_equal "No account found with this email address", flash[:alert]
    assert_nil session[:user_id]
  end

  test "should not create session with blank credentials" do
    post login_path, params: { email: "", password: "" }
    assert_response :unprocessable_entity
    assert_equal "Email and password are required", flash[:alert]
    assert_nil session[:user_id]
  end

  test "should redirect to intended page after login" do
    get tasks_path
    assert_redirected_to login_path
    
    post login_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to tasks_path
  end

  test "should destroy session" do
    post login_path, params: { email: @user.email, password: "password123" }
    assert session[:user_id].present?
    
    delete logout_path
    assert_redirected_to root_path
    assert_equal "You have been logged out successfully!", flash[:notice]
    assert_nil session[:user_id]
  end

  test "should redirect new and create when already logged in" do
    post login_path, params: { email: @user.email, password: "password123" }
    
    get login_path
    assert_redirected_to tasks_path
    assert_equal "You are already logged in.", flash[:notice]
    
    post login_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to tasks_path
    assert_equal "You are already logged in.", flash[:notice]
  end

  test "should clean email before authentication" do
    post login_path, params: { 
      email: " JOHN@EXAMPLE.COM ",
      password: "password123"
    }
    assert_redirected_to tasks_path
    assert session[:user_id].present?
  end

  test "should require login for logout" do
    delete logout_path
    assert_redirected_to login_path
  end


  test "should destroy session and redirect to root" do
    post login_path, params: { email: @user.email, password: "password123" }
    assert session[:user_id].present?
    
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
