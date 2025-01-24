class Task < ApplicationRecord
  belongs_to :project
  has_many   :user_tasks
  has_many   :users, through: :user_tasks
  belongs_to :created_by, class_name: "User"
  before_create :set_uuid
  
  private

  def set_uuid
    # Generate a UUID and set it for the 'uuid' attribute
    self.uuid ||= SecureRandom.uuid
  end
end
