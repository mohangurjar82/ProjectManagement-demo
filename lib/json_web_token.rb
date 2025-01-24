require 'jwt'

class JsonWebToken
  JWT_SECRET = Rails.application.credentials.jwt_secret_key || ENV['JWT_SECRET_KEY']

  # Encode a payload into a JWT
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  # Decode a JWT into its payload
  def self.decode(token)
    decoded = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    raise StandardError, "Invalid token: #{e.message}"
  end
end
