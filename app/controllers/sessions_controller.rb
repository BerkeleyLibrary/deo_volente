require 'hashie'

class SessionsController < ApplicationController
  # Generate a new user session using data returned from a valid Calnet login
  def callback
    @user_info = OmniAuth::AuthHash.new(request.env['omniauth.auth'])
    
    @user = User.from_omniauth(@user_info).tap do |user|
      sign_in(user)
    end

    redirect_to request.env['omniauth.origin'] || home_path
  end

  # I think this can be deleted...
  # def new
  #   authenticate!
  #   puts "------------------------------------------"
  #   puts "NEW SESSION"
  #   puts "------------------------------------------"
  #   # redirect_args = { origin: params[:url] || home_path }.to_query
  #   # redirect_to "/auth/calnet?#{redirect_args}"
    
  #   render :new
  # end

  # def create
  #   user_info = request.env['omniauth.auth']
  #   puts "------------------------------------------"
  #   puts "CREATE SESSION"
  #   puts "user_info: #{user_info}"
  #   puts "------------------------------------------"
  #   #raise user_info # Your own session management should be placed here.
  # end

  # Logout the user by redirecting to CAS logout screen
  def destroy
    sign_out

    # TODO: configure this more elegantly and make it play better with Selenium tests
    logout_url = "https://auth#{'-test' unless Rails.env.production?}.berkeley.edu/cas/logout"
    redirect_to logout_url, allow_other_host: true
  end

end
