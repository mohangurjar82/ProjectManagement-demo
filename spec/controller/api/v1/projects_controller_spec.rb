require 'rails_helper'
RSpec.describe Api::V1::ProjectsController, type: :controller do
    include LoginHelper

  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:project) }
  let(:invalid_attributes) { { name: "" } }

  before do
    # Log in the user before each request
    token = login_as(user)
    request.headers['Authorization'] = "#{token}"
  end

  describe "POST #assign_user" do
    context "when user is not already assigned" do
      it "assigns the user to the project" do
        post :assign_user, params: { project_id: project.id, user_id: user.id }, format: :json
        expect(response.body["message"]) == ("User assigned to project successfully")
      end
    end
   end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns the project" do
      get :show, params: { id: project.uuid }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new project" do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        post :create, params: { project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      it "updates the project" do
        put :update, params: { id: project.uuid, project: { name: "Updated Name" } }
        project.reload
        expect(project.name).to eq("Updated Name")
      end
    end

    context "with invalid params" do
      it "returns an error response" do
        put :update, params: { id: project.uuid, project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

describe "DELETE #remove_user" do
    context "when user is assigned to the project" do

      it "removes the user from the project" do
        delete :remove_user, params: { project_id: project.id, user_id: user.id }, format: :json
        expect(response.body["message"]) == ("User removed from project successfully")
      end
    end
  end

describe "GET #task_breakdown" do
    let!(:task) { create(:task, project: project, duration: 5) }

    it "returns task breakdown of the project" do
      get :task_breakdown, params: { id: project.uuid }, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.body["total_time"]) == (5)
      expect(response.body["tasks"]).not_to be_empty
    end
  end

  describe "DELETE #destroy" do
    it "deletes the project" do
      project = create(:project)
      expect {
        delete :destroy, params: { id: project.uuid }
      }.to change(Project, :count).by(-1)
    end
  end
end
