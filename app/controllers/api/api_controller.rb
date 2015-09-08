class Api::ApiController < ApplicationController

  respond_to :json
 
  before_action :authenticate, except: [:get_key]

  def index
    render :json => @user.to_json
  end

  def get_key
    email = request.headers['Email'].to_s
    password = request.headers['Password'].to_s
    @user = User.where(:email => email).first 
    if !@user.nil?
      if @user.valid_password?(password)
        render :json => { api_key: @user.api_key }
      else
        head status: :unauthorized
      end
    else
      head status: :bad_request
    end
  end

  def regenerate_key
    @user.generate_access_token
    @user.save
    render :json => { api_key: @user.api_key }
  end

  private
 
  def authenticate
    api_key = request.headers['Authorization'].to_s
    @user = User.where(:api_key => api_key).first if api_key

    unless @user
      head status: :unauthorized
    end
  end

end
