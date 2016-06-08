class LoginUser
  def initialize(args)
    @email = args[:email]
    @password = args[:password]
  end

  def valid?
    @email.present? &&
    @password.present? &&
    _check_and_set_user?
  end

  def perform
    return false if not valid?

    _renew_access_token
  end

  private

  def _check_and_set_user?
    @user = User.find_by_args({email: @email, encrypted_password: _get_encrypted_password}).last
    @user.present?
  end

  def _renew_access_token
    return false if @user.blank?
    @user.update_access_token
  end

  def _get_encrypted_password
    return nil if @password.blank?
    EncryptPassword.new({password: @password}).perform
  end

  def _get_access_token
    GetNewAccessToken.new.perform
  end
end
