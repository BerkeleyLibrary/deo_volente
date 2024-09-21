# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthSupport
  helper_method :current_user, :signed_in?, :dataverse_user?

  private

  def current_user
    if session[:user_id]
      {
        id: session[:user_id],
        name: session[:display_name],
        email: session[:email],
        dataverse_user: session[:dataverse_user]
      }
    end
  end

  def signed_in?
    session[:user_id].present?
  end

  def dataverse_user?
    current_user[:dataverse_user]
  end

end
