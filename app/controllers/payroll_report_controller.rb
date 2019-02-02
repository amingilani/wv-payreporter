# Depending on the values of either `params[:printer]` and `format`, this renders a human friendly
# Payroll Report, a printer friendly PayrollReport, a JSON PayrollReport, or a CSV PayrollReport
class PayrollReportController < ApplicationController
  def index
    @payroll_report = PayrollManager::Reporter.call # fetch the report
    @printer = params[:printer] == 'true' # printer friendly version?
    respond_to do |format|
      format.html
      format.json { render json: PayrollManager::ReportJsonFormatter.call(@payroll_report) }
      format.csv do
        filename = "payroll-report-#{Time.zone.now.to_date}.csv"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Content-Type'] ||= 'text/csv'
        render inline: '<%= PayrollManager::ReportCsvFormatter.call(@payroll_report) %>'
      end
    end
  end
end
