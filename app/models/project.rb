class Project < ApplicationRecord
  has_many :tasks
  has_many :assignments
  has_many :users, through: :assignments
  before_create :set_uuid
  scope :active, -> { where('start_date <= ? AND start_date + duration_day >= ?', Date.today, Date.today) }


  validates :name , presence: true

  def active?
    start_date <= Date.today && end_date >= Date.today
  end
  
  def end_date
    start_date + duration_day.days
  end

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end