class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  rescue_from Mongoid::Errors::DocumentNotFound, with: :task_not_found

  def index
    @tasks = current_user.tasks.order_by(created_at: :desc)
  rescue => e
    flash.now[:error] = "Error loading tasks. Please try again."
    @tasks = []
  end

  def show
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if @task.save
      TaskEmailJob.perform_async(@task.id.to_s)
      # AblyService.publish_task_update(@task, 'created')
      redirect_to tasks_path, notice: "Task '#{@task.title}' was created successfully!"
    else
      flash.now[:error] = @task.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  rescue => e
    flash.now[:error] = "Error creating task. Please try again."
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    if @task.update(task_params)
      # AblyService.publish_task_update(@task, 'updated')
      redirect_to tasks_path, notice: "Task '#{@task.title}' was updated successfully!"
    else
      flash.now[:error] = @task.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  rescue => e
    flash.now[:error] = "Error updating task. Please try again."
    render :edit, status: :unprocessable_entity
  end

  def destroy
    task_title = @task.title
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task '#{task_title}' was deleted successfully!" }
      format.turbo_stream { flash.now[:notice] = "Task '#{task_title}' was deleted successfully!" }
    end
  rescue => e
    flash[:error] = "Error deleting task. Please try again."
    redirect_to tasks_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end

  def task_not_found
    redirect_to tasks_path, alert: "Task not found or you don't have permission to access it."
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority)
  end
end
