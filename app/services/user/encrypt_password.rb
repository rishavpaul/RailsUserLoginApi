class EncryptPassword
  def initialize(args)
    @password = args[:password]
  end

  def valid?
    @password.present?
  end

  def perform
    return false if not valid?
    
    _encrypt_password
  end

  private

  def _encrypt_password
    Digest::SHA1.hexdigest("#{@password}")
  end
end
