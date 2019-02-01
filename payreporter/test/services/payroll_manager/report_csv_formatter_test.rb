require 'test_helper'
require 'csv'

class ReportCsvFormatter < ActionDispatch::IntegrationTest
  EXPECTED_CSV = "start_date,employee_id,amount_paid,end_date\n"\
  "2015-02-16,4,100.00,2015-02-28\n"\
  "2016-02-16,4,150.00,2016-02-29\n"\
  "2016-11-01,1,150.00,2016-11-15\n"\
  "2016-11-01,2,930.00,2016-11-15\n"\
  "2016-11-01,3,590.00,2016-11-15\n"\
  "2016-11-01,4,150.00,2016-11-15\n"\
  "2016-11-16,1,220.00,2016-11-30\n"\
  "2016-11-16,4,450.00,2016-11-30\n"\
  "2016-12-01,1,150.00,2016-12-15\n"\
  "2016-12-01,2,930.00,2016-12-15\n"\
  "2016-12-01,3,470.00,2016-12-15\n"\
  "2016-12-01,4,150.00,2016-12-15\n"\
  "2016-12-16,1,220.00,2016-12-31\n"\
  "2016-12-16,4,450.00,2016-12-31\n".freeze

  test 'creating a valid and trying to create an invalid time report' do
    post time_reports_url,
         params: {
           file: fixture_file_upload(
             Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
             'text/csv'
           )
         }
    payroll_report = PayrollManager::Reporter.call
    csv_actual = PayrollManager::ReportCsvFormatter.call payroll_report
    assert_equal EXPECTED_CSV, csv_actual
  end
end
