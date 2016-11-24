class HonestbeeController < ApplicationController

  def login
  end

  def code
    # You have to set environment variables in your local computer first for this feature.
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]
    redirect_uri = ENV["REDIRECT_URI"]
    url = "https://core.honestbee.com/oauth/authorize?client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}&response_type=code"

    redirect_to url
  end

  # In production environment,
  # you could set the redirect url to this action(GET: /honestbee/token) for Honestbee to return the authentication code.
  # In that way, you could use the returned code to do the same thing in this action
  # instead of asking user to paste the code by himself/herself.
  def token
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]
    redirect_uri = ENV["REDIRECT_URI"]

    grant_type = "authorization_code"
    code = params[:code]
    url = "https://core.honestbee.com/api/account/token"
    begin
      response = RestClient.post(url, {grant_type: grant_type, client_id: client_id, client_secret: client_secret, redirect_uri: redirect_uri, code: code}, {content_type: :json, accept: :json})
      parsed_body = JSON.parse(response.body)
      if parsed_body && parsed_body["access_token"]
        access_token = parsed_body["access_token"]
        url = "https://core.honestbee.com/api/me?access_token=#{access_token}"
        response = RestClient.get(url)
        parsed_body = JSON.parse(response.body)
        @user = User.from_omniauth_honestbee(parsed_body["user"], access_token)
        if @user.persisted?
          sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
          flash[:notice] = "Successfully logged in."
        else
          return redirect_to new_user_registration_url
        end
      else
        return redirect_to new_user_registration_url
      end
    rescue RestClient::ExceptionWithResponse => err
      flash[:alert] = "Unauthorized code"
    end

  end
end
