require 'rails_helper'

RSpec.describe Api::AuthController, type: :controller do
  let(:user_attributes) { { name: 'John Doe', email: 'john.doe@example.com', password: 'password123', password_confirmation: 'password123', role: 'user' } }
  let(:user) { create(:user) }

  describe 'POST #signup' do
    context 'when valid parameters are provided' do
      it 'creates a new user and returns a success response' do
        post :signup, params: { user: user_attributes }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq('User created successfully')
        expect(json_response['user']['email']).to eq(user_attributes[:email])
        expect(json_response['token']).not_to be_nil
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error response' do
        invalid_user_attributes = user_attributes.merge(email: nil)

        post :signup, params: { user: invalid_user_attributes }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST #login' do
    context 'when valid credentials are provided' do
      it 'returns a success response with a token' do
        post :login, params: { email: user.email, password: user.password }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Login successful')
        expect(json_response['token']).not_to be_nil
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns an unauthorized response' do
        post :login, params: { email: user.email, password: 'wrongpassword' }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end
end
