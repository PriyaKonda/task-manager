class AddPriorityFieldToTasks < Mongoid::Migration
  def self.up
    # Add priority field to existing tasks with default value "low"
    Task.all.each do |task|
      task.set(priority: "low") unless task.priority
    end
  end

  def self.down
    # Remove priority field from all tasks
    Task.collection.update_many({}, { "$unset" => { priority: "" } })
  end
end
