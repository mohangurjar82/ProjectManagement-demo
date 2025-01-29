require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:assigned_by).class_name('User') }

  describe 'callbacks' do
    it 'generates a UUID before creating the record' do
      assignment = build(:assignment) 
      expect(assignment.uuid).not_to be_nil
      assignment.save
    end
  end
end
