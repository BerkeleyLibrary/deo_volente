class DataUploadsController < ApplicationController
  include AuthSupport
  
  before_action :authorized?

  def new
    puts signed_in? && dataverse_user?
  end

  def create
    # Code to handle file upload and data processing
    uploaded_file = params[:data_upload][:file]
    if uploaded_file.present?
      # Process the file here
      flash[:notice] = "File uploaded successfully!"
      redirect_to new_data_upload_path
    else
      flash[:alert] = "Please upload a file."
      render :new
    end
  end

  private

  def authorized?
    return true if signed_in? && dataverse_user?
    render :forbidden, status: :forbidden
  end
end
