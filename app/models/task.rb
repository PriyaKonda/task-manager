class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :status, type: String, default: "pending"
  field :due_date, type: Date
  field :priority, type: String, default: "low"

  belongs_to :user

  validates :title, :status, :priority, presence: true
  validates :priority, inclusion: { in: %w[low medium high], message: "must be low, medium, or high" }
end
