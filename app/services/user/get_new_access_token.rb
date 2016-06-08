class GetNewAccessToken
  def initialize
  end

  def perform
    _get_access_token
  end

  private

  def _get_access_token
    loop do
      access_token = _generate_access_token
      break access_token unless User.valid_access_token?({access_token: access_token})
    end
  end
  
  def _generate_access_token
    SecureRandom.urlsafe_base64(User::ACCESS_TOKEN_LENGTH*3/4, false)
  end
end
