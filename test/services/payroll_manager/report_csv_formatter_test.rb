require 'test_helper'
require 'csv'

class ReportCsvFormatter < ActionDispatch::IntegrationTest
  EXPECTED_CSV = <<~HEREDOC.freeze
    employee_id,amount_paid,pay_period
    4,100.00,16/2/2015 - 28/2/2015
    4,150.00,16/2/2016 - 29/2/2016
    1,150.00,1/11/2016 - 15/11/2016
    2,930.00,1/11/2016 - 15/11/2016
    3,590.00,1/11/2016 - 15/11/2016
    4,150.00,1/11/2016 - 15/11/2016
    1,220.00,16/11/2016 - 30/11/2016
    4,450.00,16/11/2016 - 30/11/2016
    1,150.00,1/12/2016 - 15/12/2016
    2,930.00,1/12/2016 - 15/12/2016
    3,470.00,1/12/2016 - 15/12/2016
    4,150.00,1/12/2016 - 15/12/2016
    1,220.00,16/12/2016 - 31/12/2016
    4,450.00,16/12/2016 - 31/12/2016
  HEREDOC

  test 'creating a valid and trying to create an invalid time report' do
    post time_reports_url,
         params: {
           time_report: {
             file: fixture_file_upload(
               Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
               'text/csv'
             )
           }
         }
    payroll_report = PayrollManager::Reporter.call
    csv_actual = PayrollManager::ReportCsvFormatter.call payroll_report
    assert_equal EXPECTED_CSV, csv_actual
  end
end
