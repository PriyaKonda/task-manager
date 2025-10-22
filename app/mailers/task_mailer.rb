class TaskMailer < ApplicationMailer
  default from: ENV['SMTP_MAIL']

  def task_created(task)
    @task = task
    @user = task.user
    mail(
      to: @user.email,
      subject: "New Task Created"
    )
  end
end