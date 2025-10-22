require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create_test_user
    @task = create_test_task(@user)
    @task_params = {
      title: "New Task",
      description: "New Description",
      status: "pending",
      priority: "medium",
      due_date: Date.tomorrow
    }
  end

  test "should redirect when not authenticated" do
    get tasks_path
    assert_redirected_to login_path
    
    get task_path(@task)
    assert_redirected_to login_path
    
    get new_task_path
    assert_redirected_to login_path
    
    post tasks_path, params: { task: @task_params }
    assert_redirected_to login_path
    
    get edit_task_path(@task)
    assert_redirected_to login_path
    
    patch task_path(@task), params: { task: @task_params }
    assert_redirected_to login_path
    
    delete task_path(@task)
    assert_redirected_to login_path
  end

  test "should get index when authenticated" do
    login_as(@user)
    get tasks_path
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should show task when authenticated" do
    login_as(@user)
    get task_path(@task)
    assert_response :success
  end

  test "should get new task form when authenticated" do
    login_as(@user)
    get new_task_path
    assert_response :success
    assert_not_nil assigns(:task)
  end

  test "should create task when authenticated" do
    login_as(@user)
    assert_difference('Task.count') do
      post tasks_path, params: { task: @task_params }
    end
    assert_redirected_to tasks_path
    assert_equal "Task 'New Task' was created successfully!", flash[:notice]
  end

  test "should not create task with invalid params" do
    login_as(@user)
    assert_no_difference('Task.count') do
      post tasks_path, params: { task: { title: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit when authenticated" do
    login_as(@user)
    get edit_task_path(@task)
    assert_response :success
  end

  test "should update task when authenticated" do
    login_as(@user)
    patch task_path(@task), params: { task: { title: "Updated Title" } }
    assert_redirected_to tasks_path
    @task.reload
    assert_equal "Updated Title", @task.title
  end

  test "should not update task with invalid params" do
    login_as(@user)
    patch task_path(@task), params: { task: { title: "" } }
    assert_response :unprocessable_entity
  end

  test "should destroy task when authenticated" do
    login_as(@user)
    assert_difference('Task.count', -1) do
      delete task_path(@task)
    end
    assert_redirected_to tasks_path
  end

  test "should not access other user's task" do
    other_user = create_test_user(email: "other@example.com")
    other_task = create_test_task(other_user)

    login_as(@user)
    
    get task_path(other_task)
    assert_redirected_to tasks_path
    assert_equal "Task not found or you don't have permission to access it.", flash[:alert]
    
    get edit_task_path(other_task)
    assert_redirected_to tasks_path
    assert_equal "Task not found or you don't have permission to access it.", flash[:alert]
    
    patch task_path(other_task), params: { task: { title: "Hacked" } }
    assert_redirected_to tasks_path
    assert_equal "Task not found or you don't have permission to access it.", flash[:alert]
    
    delete task_path(other_task)
    assert_redirected_to tasks_path
    assert_equal "Task not found or you don't have permission to access it.", flash[:alert]
  end

  private

  def login_as(user)
    post login_path, params: { email: user.email, password: user.password }
  end
end
