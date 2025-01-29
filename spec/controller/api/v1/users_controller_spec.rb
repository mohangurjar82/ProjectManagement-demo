require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include LoginHelper
  
  let!(:admin) { create(:user, role: 'admin') }
  let!(:user) { create(:user, role: 'user') }
  let!(:other_user) { create(:user) }
  let!(:project) { create(:project, users: [user]) }
  let!(:task) { create(:task, project: project) }

  before do
    # Log in the user before each request
    token = login_as(user)
    request.headers['Authorization'] = "#{token}"
  end

  describe 'GET #index' do
    it 'returns a list of all users' do
      create_list(:user, 3)
      get :index
      expect(response).to have_http_status(:ok)
      users = JSON.parse(response.body)
      expect(users.size).to eq(User.count)
    end
  end

  describe 'GET #projects' do
    context 'when the user exists' do
      it 'returns the user’s projects with tasks included' do
        get :projects, params: { id: user.uuid }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['id']).to eq(project.id)
        expect(parsed_response.first['tasks'].first['id']).to eq(task.id)
      end
    end
  end

  describe 'GET #assigned_users' do
    context 'when the project exists' do
      it 'returns a list of users not assigned to the project' do
        unassigned_user = create(:user)
        get :assigned_users, params: { project_id: project.id }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.map { |u| u['id'] }).to include(unassigned_user.id)
        expect(parsed_response.map { |u| u['id'] }).not_to include(user.id)
      end
    end
  end
end
