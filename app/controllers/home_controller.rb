class HomeController < ApplicationController
  # All users must be authorized to access the home page
  # before_action :authorize!

  def index
  end
end

private

def authorize!
  # TODO: is there a cleaner way to do this?
  # return if Rails.env.development?
  
  authenticate!

  # raise Error::ForbiddenError unless current_user.ucb_staff?
end