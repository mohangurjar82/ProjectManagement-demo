class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :task_breakdown, :update, :destroy]

  def index
    @projects = Project.all
    render json: @projects
  end

  # GET /projects/:id
  def show
    render json: @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:id
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content
  end

  def active
    @projects = Project.active.includes(:users)
    render json: @projects, include: [:users]
  end

  def assign_user
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])

    # Assuming you have `current_user` representing the admin or the assigner
    assigned_by = user

    # Check if user is already assigned to this project
    if project.users.include?(user)
      render json: { error: "User is already assigned to this project" }, status: :unprocessable_entity
    else
      project.assignments.create!(
        user: user,
        assigned_by: assigned_by
      )
      render json: { message: "User assigned to project successfully" }
    end
  end

  def remove_user
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])

    # Check if the user is actually assigned to the project
    if project.users.include?(user)
      # Assuming you have a join model `Assignment` between Project and User
      project.assignments.find_by(user: user)&.destroy
      render json: { message: "User removed from project successfully" }
    else
      render json: { error: "User is not assigned to this project" }, status: :unprocessable_entity
    end
  end

  def task_breakdown
    tasks = @project.tasks
    task_summary = tasks.map do |task|
      {
        task: task.name,
        duration: "#{task.duration} hours",
        time_frame: "#{task.start_time} - #{task.end_time}",
        description: task.description,
        start_time: task.start_time,
        end_time: task.end_time,
        id: task.id
      }
    end
    total_time = tasks.sum(&:duration)
    render json: { tasks: task_summary, total_time: total_time, project_name: @project.name }
  end

  private

  def set_project
    @project = Project.find_by(uuid: params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :start_date, :duration_day, :duration_timeframe)
  end
end
