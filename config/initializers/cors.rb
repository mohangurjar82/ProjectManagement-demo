Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://c7d7-2401-4900-1c19-a29c-93c3-b2d7-35b8-4ad1.ngrok-free.app'  # Replace with your ngrok URL
    resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete]
  end
end