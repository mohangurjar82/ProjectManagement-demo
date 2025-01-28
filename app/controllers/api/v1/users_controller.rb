class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :projects]

  def index
    users = User.all
    render json: users
  end

  def projects
    @projects = @user.projects.includes(:tasks)
    render json: @projects, include: [:tasks]
  end

  def assigned_users
    project = Project.find(params[:project_id])
    all_users = User.where.not(role: 'admin')
    assigned_users = project.users
    available_users = all_users.reject { |user| assigned_users.include?(user) }
    render json: available_users
  end

  private

  def set_user
    @user = User.find_by(uuid: params[:id])
  end
end
