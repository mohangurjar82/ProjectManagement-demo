class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :task_breakdown]

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
    @projects = Project.active
    render json: @projects
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


  def task_breakdown
    tasks = @project.tasks
    task_summary = tasks.map do |task|
      {
        task: task.name,
        duration: "#{task.duration} hours",
        time_frame: "#{task.start_time} - #{task.end_time}"
      }
    end
    total_time = tasks.sum(&:duration)
    render json: { tasks: task_summary, total_time: total_time }
  end

  private

  def set_project
    @project = Project.find_by(uuid: params[:id])
  end
end
