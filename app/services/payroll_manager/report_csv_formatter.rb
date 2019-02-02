require 'csv'

module PayrollManager
  # This takes a Payroll Report and outputs the same in CSV — ready to download from our application
  class ReportCsvFormatter < ApplicationService
    def initialize(report)
      @report = report
    end

    def call
      decoration(@report)
    end

    private

    # return the CSV file as a string
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
