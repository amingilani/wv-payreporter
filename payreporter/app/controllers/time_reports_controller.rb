class TimeReportsController < ApplicationController
  def create
    file = params[:file]
    report = TimeReport.new(file: file)
    return redirect_to root_path if report.save
    redirect_to root_path, alert: report.errors.messages.values.join(' ')
  end
end
