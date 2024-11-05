# frozen_string_literal: true

# ApplicationController is the base controller class for all controllers in the application.
class ApplicationController < ActionController::Base
  include Pagy::Backend
  include AuthSupport
  helper_method :current_user, :signed_in?, :dataverse_user?

  private

  def current_user
    return unless session[:user_id]

    {
      id: session[:user_id],
      name: session[:display_name],
      email: session[:email],
      dataverse_user: session[:dataverse_user]
    }
  end

  def signed_in?
    session[:user_id].present?
  end

  def dataverse_user?
    current_user[:dataverse_user]
  end
end
