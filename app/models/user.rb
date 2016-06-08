class User < ActiveRecord::Base  
  # DATA PROPERTIES
  ACCESS_TOKEN_LENGTH = 20
  ACCESS_TOKEN_VALIDITY = 30.days
  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 30
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # LOG TYPES
  LOG = {
          creation_failure: "user_creation_failure",
          login_failure: "user_login_failure",
          update_failure: "user_update_failure"
        }

  validates :email, :name, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Please use valid email' }, if: Proc.new {|u| u.email?}

  # PUBLIC CLASS METHODS
  def self.valid_access_token?(args)
    return false if args[:access_token].blank?

    exists?(args[:access_token])
  end

  def self.create_user(args)
    return false if not create_user_valid_args?(args)

    begin
      user = create!( name: args[:name],
                      email: args[:email],
                      encrypted_password: args[:encrypted_password],
                      access_token: args[:access_token],
                      access_token_valid_upto: args[:access_token_valid_upto]
                    )
    rescue Exception => e
      CommonHelper::log(LOG[:creation_failure], e.message)
      return false
    end
    user
  end

  def self.get_access_token_valid_upto
    Time.zone.now + ACCESS_TOKEN_VALIDITY
  end

  def self.find_by_args(args)
    args = filter_active_record_attributes(args)
    return [] if args.blank?
    
    User.where(args)
  end

  # PUBLIC INSTANCE METHODS
  def update_access_token
    self.access_token = GetNewAccessToken.new.perform
    self.access_token_valid_upto = Time.zone.now + ACCESS_TOKEN_VALIDITY
    update_user!
    self.access_token
  end

  protected

  # PROTECTED CLASS METHODS
  def self.create_user_valid_args?(args)
    CommonHelper::ensure_presence_of( args[:name],
                                      args[:email],
                                      args[:encrypted_password],
                                      args[:access_token],
                                      args[:access_token_valid_upto])
  end

  def self.filter_active_record_attributes(args)
    columns = User.column_names.map(&:to_s)
    args.select{|key, value| columns.include?(key.to_s)}
  end

  # PROTECTED INSTANCE METHODS
  def update_user!
    begin
      self.save!
    rescue Exception => e
      CommonHelper::log(LOG[:update_failure], e.message)
    end
  end

end
