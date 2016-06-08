class UsersController < ApplicationController
  def login
    response = LoginUser.new(email: params[:email], password: params[:password]).perform
    if !response
      render :json => {status: 'failure'}, status: 400
    else
      render :json => {status: 'success', access_token: response}
    end
  end
  

  def signup
    response = CreateUser.new(email: params[:email],
                              password: params[:password],
                              re_entered_password: params[:re_entered_password],
                              name: params[:name]).perform
    
    if !response
      render :json => {status: 'failure'}, status: 400
    else
      render :json => {status: 'success', access_token: response}
    end
  end

  def signout
    binding.pry
  end

  private
    
  def signup_params
    params.permit(:email, :password)
  end
end
