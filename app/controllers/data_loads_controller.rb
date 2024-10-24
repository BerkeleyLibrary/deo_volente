# frozen_string_literal: true

# DataLoadsController is responsible for handling file uploads and data processing.
# It includes authentication support and ensures that only authorized users can access its actions.
class DataLoadsController < ApplicationController
  include AuthSupport

  before_action :authorized?

  # GET /data_loads
  def index
    # Rather than hack pagy to pass show_archived as a param, we'll use the
    # session variable to hide/show archived dataloads
    archive_param = params[:show_archived] || session[:show_archived] || 'false'

    session[:show_archived] = archive_param != 'false'

    @sort_by = params[:sort_by] || 'id'
    @sort_direction = params[:direction] == 'desc' ? 'desc' : 'asc'

    if session[:show_archived]
      @pagy, @data_loads = pagy(Dataload.order("#{@sort_by} #{@sort_direction}"))
    else
      @pagy, @data_loads = pagy(Dataload.where.not(archived: true).order("#{@sort_by} #{@sort_direction}"))
    end
  end

  # GET /data_loads/1
  def show
    @data_load = Dataload.find(params[:id])
  end

  # TODO: Form to create new dataload
  def new; end

  # TODO: Create a new dataload!!!
  def create; end

  def update
    @data_load = Dataload.find(params[:id])
    # s@data_load.update(archived: true)
    redirect_to data_loads_path
  end

  private

  def authorized?
    return true if signed_in? && dataverse_user?

    render :forbidden, status: :forbidden
  end
end
