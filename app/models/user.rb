class User < ApplicationRecord
  has_secure_password

  has_many :assignments
  has_many :projects, through: :assignments
  has_many :user_tasks
  has_many :tasks, through: :user_tasks
  enum role: { admin: 'Admin', user: 'User' }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :role
  before_create :set_uuid

  private

  def set_uuid
    # Generate a UUID and set it for the 'uuid' attribute
    self.uuid ||= SecureRandom.uuid
  end
end
