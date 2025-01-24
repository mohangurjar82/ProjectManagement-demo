class Api::V1::TasksController < ApplicationController
 before_action :set_project

  def index
    if @project.users.include?(current_user)
      @tasks = @project.tasks
      render json: @tasks, status: :ok
    else
      render json: { error: "You are not assigned to this project." }, status: :forbidden
    end
  end

  def create
    if @project.users.include?(current_user) && @project.active?
      @task = @project.tasks.new(task_params)
      @task.created_by = current_user
      if @task.save
        render json: @task, status: :created
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "You are not assigned to this project or the project is not active." }, status: :forbidden
    end
  end

  private

  def set_project
    @project = Project.find_by(uuid: params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :start_time, :end_time, :duration)
  end
end
