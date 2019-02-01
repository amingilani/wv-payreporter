require 'csv'

module PayrollManager
  # This takes a regular report and outputs a beautifully formatted JSON report
  # ready to render from our API
  class ReportCsvFormatter < ApplicationService
    def initialize(report)
      @report = report
    end

    def call
      decoration(@report)
    end

    private

    def decoration(report)
      CSV.generate do |csv|
        csv << report.first.keys
        report.each do |record|
          csv << record.values
        end
      end
    end
  end
end
