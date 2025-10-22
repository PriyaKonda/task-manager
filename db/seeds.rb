# db/seeds.rb

# Clear existing data (optional - be careful in production!)
puts "Clearing existing data..."
Task.delete_all
User.delete_all

# Create users
puts "Creating users..."
users = []

users << User.create!(
  email: "john@example.com",
  name: "John Doe",
  password: "password123"
)

users << User.create!(
  email: "jane@example.com",
  name: "Jane Smith",
  password: "password123"
)

users << User.create!(
  email: "admin@example.com",
  name: "Admin User",
  password: "password123"
)

puts "Created #{users.count} users"

# Create tasks
puts "Creating tasks..."

tasks_data = [
  {
    title: "Complete project proposal",
    description: "Write and submit the Q4 project proposal",
    status: "pending",
    priority: "high",
    due_date: Date.today + 7.days,
    user: users[0]
  },
  {
    title: "Review code changes",
    description: "Review pull requests from the team",
    status: "in_progress",
    priority: "medium",
    due_date: Date.today + 2.days,
    user: users[0]
  },
  {
    title: "Update documentation",
    description: "Update API documentation with new endpoints",
    status: "pending",
    priority: "low",
    due_date: Date.today + 14.days,
    user: users[1]
  },
  {
    title: "Fix bug in authentication",
    description: "Resolve the OAuth login issue",
    status: "completed",
    priority: "high",
    due_date: Date.today - 2.days,
    user: users[1]
  },
  {
    title: "Team meeting preparation",
    description: "Prepare slides for weekly team meeting",
    status: "pending",
    priority: "medium",
    due_date: Date.today + 1.day,
    user: users[2]
  }
]

tasks_data.each do |task_attrs|
  Task.create!(task_attrs)
end

puts "Created #{Task.count} tasks"
puts "Seeding complete!"