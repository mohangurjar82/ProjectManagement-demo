module LoginHelper
  def login_as(user)
    token = JsonWebToken.encode(user_id: user.id)
  end
end
