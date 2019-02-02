
class PayrollReportController < ApplicationController
  def index
    @payroll_report = PayrollManager::Reporter.call # fetch the report
    @printer = params[:printer] == 'true' # printer friendly version?
    respond_to do |format|
      format.html
      format.json { render json: PayrollManager::ReportJsonFormatter.call(@payroll_report) }
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"payroll-report-#{Time.zone.now.to_date}.csv\""
        headers['Content-Type'] ||= 'text/csv'
        render inline: '<%= PayrollManager::ReportCsvFormatter.call(@payroll_report) %>'
      end
    end
  end
end
