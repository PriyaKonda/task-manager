require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    User.destroy_all
    Task.destroy_all
    @user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    )
  end

  test "valid user" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
    assert_includes @user.errors[:name], "can't be blank"
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "password should be present" do
    @user.password = "   "
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "password should have minimum length" do
    @user.password = "short"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 6 characters)"
  end

  test "should authenticate with correct password" do
    @user.save
    assert @user.authenticate("password123")
  end

  test "should not authenticate with incorrect password" do
    @user.save
    assert_not @user.authenticate("wrongpassword")
  end

  test "should have encrypted password after save" do
    @user.save
    assert_not_nil @user.password_digest
    assert_not_equal "password123", @user.password_digest
  end

  test "should destroy associated tasks when user is destroyed" do
    @user.save!
    task = Task.create!(
      title: "Test Task",
      priority: "low",
      status: "pending",
      user: @user
    )
    assert_difference "Task.count", -1 do
      @user.destroy
    end
  end
end
