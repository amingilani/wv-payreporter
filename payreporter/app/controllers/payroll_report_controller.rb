class PayrollReportController < ApplicationController
  def index
    @payroll_report = PayrollReporter.call
  end
end
