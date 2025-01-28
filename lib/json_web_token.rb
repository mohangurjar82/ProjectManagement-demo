require 'jwt'

class JsonWebToken
  JWT_SECRET = Rails.application.credentials.jwt_secret_key || ENV['JWT_SECRET_KEY']

  # Encode a payload into a JWT
  def self.encode(payload)
    JWT.encode(payload, JWT_SECRET)
  end
  # Decode the JWT token
  def self.decode(token)
    decoded = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')
    decoded.first
  rescue JWT::DecodeError => e
    nil
  end
end
