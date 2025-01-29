require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:project) }
  it { should belong_to(:created_by).class_name('User') }
  it { should have_many(:user_tasks) }
  it { should have_many(:users).through(:user_tasks) }

  describe 'callbacks' do
    it 'generates a UUID before creating the record' do
      task = build(:task)  
      expect(task.uuid).not_to be_nil
      task.save
    end
  end
end
