require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  include LoginHelper
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [user]) }
  let(:other_user) { create(:user) }
  let(:task_params) do
    {
      name: 'Test Task',
      description: 'Task description',
      start_time: Time.current,
      end_time: Time.current + 1.hour,
      duration: 60
    }
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

   before do
    # Log in the user before each request
     token = login_as(user)
     request.headers['Authorization'] = "#{token}"
   end

  describe 'GET #index' do
    context 'when the user is assigned to the project' do
      it 'returns a list of tasks with status :ok' do
        task = create(:task, project: project)
        get :index, params: { project_id: project.uuid }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(JSON.parse(task.to_json))
      end
    end

    context 'when the user is not assigned to the project' do
      before do
        allow(controller).to receive(:current_user).and_return(other_user)
      end

      it 'returns a forbidden status with an error message' do
        get :index, params: { project_id: project.uuid }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not assigned to this project.')
      end
    end
  end

  describe 'POST #create' do
    context 'when the user is assigned to the project and the project is active' do

      it 'creates a new task and returns status :created' do
        expect {
          post :create, params: { project_id: project.uuid, task: task_params }
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq(task_params[:name])
      end
    end

    context 'when the user is not assigned to the project' do
      before do
        allow(controller).to receive(:current_user).and_return(other_user)
      end

      it 'returns a forbidden status with an error message' do
        post :create, params: { project_id: project.uuid, task: task_params }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not assigned to this project or the project is not active.')
      end
    end
  end
end
