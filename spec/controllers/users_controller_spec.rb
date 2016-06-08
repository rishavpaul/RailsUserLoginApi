require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before :all do
    @email = 'testuser123@gmail.com'
    @password = 'testuser123'
    name = "Test User"
    @user = User.create(email: @email, encrypted_password: EncryptPassword.new({password: @password}).perform, name: name)
  end

  describe "login" do
    it "should login for existing users and return access token" do
      post :login, {email: @email, password: @password}
      @user.reload
      expect(response.status).to eql(200)
      expect(@user.access_token == response[:access_token])
    end

    it "should return access token and update access token validity to future" do
      post :login, {email: @email, password: @password}
      @user.reload
      expect(response.status).to eql(200)
      expect(@user.access_token == response[:access_token])
      expect(Time.zone.parse(@user.access_token_valid_upto)) > Time.zone.now + User::ACCESS_TOKEN_VALIDITY - 2.seconds
    end
  end

  describe "signup" do
    it "should signup if password and reenter-passwords match" do
    
    end
  end
end
