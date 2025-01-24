class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :projects]

  def projects
    @projects = @user.projects
    render json: @projects
  end

  private

  def set_user
    @user = User.find(uuid: params[:id])
  end
end
