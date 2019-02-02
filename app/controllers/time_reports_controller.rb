# This appropriately creates `TimeReport`s, and handles page redirection back to the root_path,
# along with the appropriate `flash` message
class TimeReportsController < ApplicationController
  def create
    file = params[:time_report][:file]
    raise unless file.content_type == 'text/csv'

    report = TimeReport.new(file: file)

    if report.save
      flash[:success] = 'Time report successfully saved.'
      return redirect_to root_path
    end

    flash[:warn] = report.errors.messages.values.join(' ')
    redirect_to root_path
  rescue StandardError
    flash[:warn] = 'File not uploaded, or invalid.'
    redirect_to root_path
  end
end
