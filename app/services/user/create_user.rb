class CreateUser
  def initialize(args)
    @name = args[:name]
    @password = args[:password]
    @re_entered_password = args[:password]
    @email = args[:email]
  end

  def valid?
    @email.present? &&
    _is_email_valid? &&
    @name.present? &&
    User.find_by_args({email: @email}).blank? &&
    @password.present? &&
    @re_entered_password.present? &&
    @password == @re_entered_password &&
    @password.length >= User::MIN_PASSWORD_LENGTH &&
    @password.length <= User::MAX_PASSWORD_LENGTH
  end

  def perform
    return false if not valid?
    
    _create_user
  end

  private

  def _create_user 
    user = User.create_user(name: @name,
                            email: @email,
                            encrypted_password: _get_encrypted_password,
                            access_token: _get_access_token,
                            access_token_valid_upto:  _get_access_token_valid_upto)
    
    user.present? ? user.access_token : false
  end

  def _get_encrypted_password
    return nil if @password.blank?
    EncryptPassword.new({password: @password}).perform
  end

  def _get_access_token
    GetNewAccessToken.new.perform
  end

  def _get_access_token_valid_upto
    User.get_access_token_valid_upto
  end

  def _is_email_valid?
    User::VALID_EMAIL_REGEX.match(@email).to_s == @email
  end
end
