require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Task Test User",
      email: "tasktest@example.com",
      password: "password123"
    )
    @task = Task.new(
      title: "Test Task",
      description: "This is a test task",
      status: "pending",
      priority: "low",
      due_date: Date.tomorrow,
      user: @user
    )
  end

  def teardown
    User.destroy_all
    Task.destroy_all
  end

  test "valid task" do
    assert @task.valid?
  end

  test "title should be present" do
    @task.title = "   "
    assert_not @task.valid?
    assert_includes @task.errors[:title], "can't be blank"
  end

  test "status should be present" do
    @task.status = "   "
    assert_not @task.valid?
    assert_includes @task.errors[:status], "can't be blank"
  end

  test "priority should be present" do
    @task.priority = "   "
    assert_not @task.valid?
    assert_includes @task.errors[:priority], "can't be blank"
  end

  test "priority should be included in the list" do
    @task.priority = "invalid"
    assert_not @task.valid?
    assert_includes @task.errors[:priority], "must be low, medium, or high"
  end

  test "priority should accept valid values" do
    valid_priorities = %w[low medium high]
    valid_priorities.each do |priority|
      @task.priority = priority
      assert @task.valid?, "#{priority} should be a valid priority"
    end
  end

  test "should belong to a user" do
    @task.user = nil
    assert_not @task.valid?
    assert_includes @task.errors[:user], "can't be blank"
  end

  test "should have default status of pending" do
    new_task = Task.new
    assert_equal "pending", new_task.status
  end

  test "should have default priority of low" do
    new_task = Task.new
    assert_equal "low", new_task.priority
  end
end
