class Api::AuthController < ApplicationController
  skip_before_action :authenticate_request

  def signup
    @user = User.new(user_params)
    
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { message: 'User created successfully', token: token }, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def login
    @user = User.find_by(email: params[:email])
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { message: 'Login successful', token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
