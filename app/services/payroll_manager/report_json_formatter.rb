module PayrollManager
  # This takes a regular report and outputs a beautifully formatted JSON report
  # ready to render from our API
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
