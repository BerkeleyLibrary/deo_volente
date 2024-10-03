# frozen_string_literal: true

# DataUploadsController is responsible for handling file uploads and data processing.
# It includes authentication support and ensures that only authorized users can access its actions.
class DataUploadsController < ApplicationController
  include AuthSupport

  before_action :authorized?

  def new; end

  def create
    # Code to handle file upload and data processing
    uploaded_file = params[:data_upload][:file]
    if uploaded_file.present?
      # TODO: Process the file here
      # flash[:notice] = 'File uploaded successfully!'
      redirect_to new_data_upload_path
    else
      # flash[:alert] = 'Please upload a file.'
      render :new
    end
  end

  private

  def authorized?
    return true if signed_in? && dataverse_user?

    render :forbidden, status: :forbidden
  end
end
