class AblyService
  class << self
    def client
      @client ||= Ably::Rest.new(key: ENV['ABLY_API_KEY'])
    end

    def publish_task_update(task, action)
      begin
        channel = client.channels.get("tasks-#{task.user_id}")
        
        data = {
          action: action,
          task: {
            id: task.id.to_s,
            title: task.title,
            description: task.description,
            status: task.status,
            priority: task.priority,
            due_date: task.due_date&.iso8601
          }
        }

        channel.publish('task-update', data)
      rescue StandardError => e
        Rails.logger.error "Ably publish error: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end

    def generate_client_token(user_id)
      token_params = {
        client_id: "user-#{user_id}",
        capability: {
          "tasks-#{user_id}" => ['subscribe']
        }
      }
      
      client.auth.create_token_request(token_params)
    rescue StandardError => e
      Rails.logger.error "Ably token error: #{e.message}\n#{e.backtrace.join("\n")}"
      nil
    end
  end
end