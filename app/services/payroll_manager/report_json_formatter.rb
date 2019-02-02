module PayrollManager
  # This takes a Payroll Report and outputs the same as a hash — to render from our API as JSON
  class ReportJsonFormatter < ApplicationService
    def initialize(report)
      @report = report
    end

    def call
      decoration(@report)
    end

    private

    def decoration(report)
      report.map do |e|
        e[:amount_paid] = e[:amount_paid].format
        e
      end
    end
  end
end
