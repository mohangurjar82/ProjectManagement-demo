class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  # Authenticate the request by decoding the JWT token
  def authenticate_request
    token = extract_token_from_header
    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded['user_id'])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :unauthorized
      rescue StandardError => e
        render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :unauthorized
    end
  end

  # Extract the token from the Authorization header
  def extract_token_from_header
    auth_header = request.headers['Authorization']
    auth_header&.split(' ')&.last
  end

  # Access the currently authenticated user
  def current_user
    @current_user
  end
end
