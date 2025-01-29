require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:tasks) }
    it { should have_many(:assignments) }
    it { should have_many(:users).through(:assignments) }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:active_project) { create(:project, start_date: 10.days.ago, duration_day: 10) }
      let!(:inactive_project) { create(:project, start_date: 20.days.ago, duration_day: 5) }

      it 'returns projects that are active' do
        expect(Project.active).to include(active_project)
        expect(Project.active).not_to include(inactive_project)
      end
    end
  end

  describe 'instance methods' do
    let(:project) { create(:project, start_date: 5.days.ago, duration_day: 10) }

    describe '#active?' do
      it 'returns true if the project is active' do
        expect(project.active?).to be(true)
      end

      it 'returns false if the project is not active' do
        project.update(start_date: 30.days.ago, duration_day: 5)
        expect(project.active?).to be(false)
      end
    end

    describe '#end_date' do
      it 'calculates the end date correctly' do
        expect(project.end_date).to eq(project.start_date + project.duration_day.days)
      end
    end
  end

  describe 'callbacks' do
      it 'does not overwrite UUID if provided' do
        custom_uuid = 'custom-uuid-123'
        project = Project.create(start_date: Date.today, duration_day: 5, uuid: custom_uuid)
        expect(project.uuid).to eq(custom_uuid)
    end
  end
end
