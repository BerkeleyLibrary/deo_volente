# frozen_string_literal: true

require 'hashie'

# SessionsController is responsible for handling user login and logout.
class SessionsController < ApplicationController
  # Generate a new user session using data returned from a valid Calnet login
  def callback
    @user_info = OmniAuth::AuthHash.new(request.env['omniauth.auth'])

    @user = User.from_omniauth(@user_info).tap do |user|
      sign_in(user)
    end

    redirect_to request.env['omniauth.origin'] || home_path
  end

  # Logout the user by redirecting to CAS logout screen
  def destroy
    sign_out

    logout_url = "https://auth#{'-test' unless Rails.env.production?}.berkeley.edu/cas/logout"
    redirect_to logout_url, allow_other_host: true
  end
end
