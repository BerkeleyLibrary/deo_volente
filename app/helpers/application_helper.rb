# frozen_string_literal: true

# ApplicationHelper module
# This module contains helper methods that are available to all views
# in the application. You can add methods here that you want to use
# across multiple views.
module ApplicationHelper
  include Pagy::Frontend

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort_by] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, sort_by: column, direction:
  end

  def format_datetime(time, format: '%Y-%b-%d %H:%M')
    return if time.blank?

    time.in_time_zone('Pacific Time (US & Canada)').strftime(format)
  end
end
