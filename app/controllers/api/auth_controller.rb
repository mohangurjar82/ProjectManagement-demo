class Api::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:signup, :login]

   def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user.id)
      render json: { message: 'User created successfully', token: token, user: user_response(user) }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { message: 'Login successful', token: token, user: user_response(user) }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

   def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      created_at: user.created_at,
      role: user.role,
      uuid: user.uuid

    }
  end
end
