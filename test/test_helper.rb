ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    def load_fixture(name)
      YAML.load_file(File.join(Rails.root, "test", "fixtures", "#{name}.yml"))
    end
    
    setup do
      Mongoid.purge!
    end

    private

    def create_test_user(attributes = {})
      default_attributes = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123"
      }
      User.create!(default_attributes.merge(attributes))
    end

    def create_test_task(user, attributes = {})
      default_attributes = {
        title: "Test Task",
        description: "Test Description",
        status: "pending",
        priority: "low",
        due_date: Date.tomorrow
      }
      user.tasks.create!(default_attributes.merge(attributes))
    end
  end
end
