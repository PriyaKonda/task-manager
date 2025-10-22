class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

  has_many :tasks, dependent: :destroy

  attr_accessor :password

  before_save :encrypt_password

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6}, if: -> {new_record? || !password.present?}


  def authenticate(plain_password)
    BCrypt::Password.new(password_digest) == plain_password
  end

  private

    def encrypt_password
      self.password_digest = BCrypt::Password.create(password) if password.present?
    end

    def password_matches_confirmation
      if password.present? && password != password_confirmation
        errors.add(:password_confirmation, "doesn't match Password")
      end
    end
end
