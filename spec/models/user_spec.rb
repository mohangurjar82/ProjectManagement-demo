# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email: 'user@example.com', password: 'password', role: 'user')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(password: 'password', role: 'user')
    expect(user).not_to be_valid
  end

  it 'is invalid with a duplicate email' do
    User.create(email: 'user@example.com', password: 'password', role: 'user')
    user = User.new(email: 'user@example.com', password: 'password', role: 'user')
    expect(user).not_to be_valid
  end

  it 'is invalid without a password' do
    user = User.new(email: 'user@example.com', role: 'user')
    expect(user).not_to be_valid
  end

  it 'is invalid with a password shorter than 6 characters' do
    user = User.new(email: 'user@example.com', password: 'short', role: 'user')
    expect(user).not_to be_valid
  end

  it 'is invalid without a role' do
    user = User.new(email: 'user@example.com', password: 'password')
    expect(user).not_to be_valid
  end

  it 'is valid with a role of "admin" or "user"' do
    admin_user = User.new(email: 'admin@example.com', password: 'password', role: 'admin')
    regular_user = User.new(email: 'user@example.com', password: 'password', role: 'user')
    expect(admin_user).to be_valid
    expect(regular_user).to be_valid
  end

  it { should have_many(:assignments) }
  it { should have_many(:projects).through(:assignments) }
  it { should have_many(:user_tasks) }
  it { should have_many(:tasks).through(:user_tasks) }

  it 'has a role of "admin" as an admin' do
    user = User.new(email: 'admin@example.com', password: 'password', role: 'admin')
    expect(user.admin?).to be true
  end

  it 'has a role of "user" as a user' do
    user = User.new(email: 'user@example.com', password: 'password', role: 'user')
    expect(user.user?).to be true
  end

  it 'generates a UUID before creating the user' do
    user = User.create(email: 'user@example.com', password: 'password', role: 'user')
    expect(user.uuid).to be_present
    expect(user.uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
  end
end
