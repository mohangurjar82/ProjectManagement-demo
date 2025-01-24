# app/services/json_web_token.rb
class JsonWebToken
  # Secret key to encode and decode JWT tokens
  SECRET_KEY = Rails.application.secret_key_base.to_s
  # Encode the payload into a JWT token
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end
  # Decode the JWT token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    decoded.first
  rescue JWT::DecodeError => e
    nil
  end
end
