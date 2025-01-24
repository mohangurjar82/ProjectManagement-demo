class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :assigned_by, class_name: "User"
  before_create :set_uuid

  private

  def set_uuid
    # Generate a UUID and set it for the 'uuid' attribute
    self.uuid ||= SecureRandom.uuid
  end
end
