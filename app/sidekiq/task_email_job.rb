class TaskEmailJob
  include Sidekiq::Job
  sidekiq_options retry: 3 # Limit retries to 3 attempts

  def perform(task_id)
    # Try to find the task, return if it doesn't exist
    task = Task.find(task_id)
    TaskMailer.task_created(task).deliver_now
  rescue Mongoid::Errors::DocumentNotFound => e
    # Log the error but don't retry - the task is gone
    logger.info "Task #{task_id} was not found, possibly deleted. Skipping email."
    return # Don't retry, just exit gracefully
  rescue StandardError => e
    # Log other errors and let Sidekiq handle retries
    logger.error "Error in TaskEmailJob for task #{task_id}: #{e.message}"
    raise # Re-raise the error for Sidekiq to handle
  end
end
