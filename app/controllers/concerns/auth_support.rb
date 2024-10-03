# frozen_string_literal: true

# AuthSupport is a concern that provides methods for authenticating users.
module AuthSupport
  extend ActiveSupport::Concern

  private

  # Require that the current user be authenticated
  #
  # @return [void]
  # @raise [Error::UnauthorizedError] If the user is not
  #   authenticated
  def authenticate!
    redirect_to main_app.login_path(url: request.fullpath) unless authenticated?
  end

  # Return whether the current user is authenticated
  #
  # @return [Boolean]
  def authenticated?
    signed_in?
  end

  # Return the current user
  #
  # This always returns a user object, even if the user isn't authenticated.
  # Call {User#authenticated?} to determine if they were actually auth'd, or
  # use the shortcut {#authenticated?} to see if the current user is auth'd.
  #
  # @return [User]
  def current_user
    @current_user ||= User.new(session[:user] || {})
  end

  # Sign in the user by storing their data in the session
  #
  # @param [User]
  # @return [void]
  def sign_in(user)
    session[:user] = user
    session[:user_id] = user.uid
    session[:email] = user.email
    session[:dataverse_user] = user.dataverse_user?
    session[:display_name] = user.display_name
  end

  # Sign out the current user by clearing all session data
  #
  # @return [void]
  def sign_out
    reset_session
  end

  def signed_in?
    current_user.authenticated?
  end
end
