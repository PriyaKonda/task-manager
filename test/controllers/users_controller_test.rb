require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user_params = {
      name: "New User",
      email: "new@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
    @existing_user = create_test_user
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should create user with valid params" do
    assert_difference('User.count') do
      post users_path, params: { user: @user_params }
    end
    assert_redirected_to login_path
    assert_equal 'Account created successfully! Please log in.', flash[:notice]
  end

  test "should not create user with invalid params" do
    assert_no_difference('User.count') do
      post users_path, params: { user: @user_params.merge(email: '') }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with duplicate email" do
    assert_no_difference('User.count') do
      post users_path, params: { user: @user_params.merge(email: @existing_user.email) }
    end
    assert_response :unprocessable_entity
  end

  test "should redirect new if already logged in" do
    user = User.create!(@user_params)
    post login_path, params: { email: user.email, password: user.password }
    
    get signup_path
    assert_redirected_to tasks_path
    assert_equal "You are already logged in.", flash[:notice]
    
    post users_path, params: { user: @user_params }
    assert_redirected_to tasks_path
    assert_equal "You are already logged in.", flash[:notice]
  end

  test "should clean email before saving" do
    dirty_email = " TEST@EXAMPLE.COM "
    assert_difference('User.count') do
      post users_path, params: { 
        user: @user_params.merge(email: dirty_email)
      }
    end
    assert_equal "test@example.com", User.last.email
  end
end
