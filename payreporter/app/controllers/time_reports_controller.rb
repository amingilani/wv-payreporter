class TimeReportsController < ApplicationController
  def create
    file = params[:file]
    report = TimeReport.new(file: file)
    byebug
  end
end
