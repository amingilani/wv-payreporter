require 'test_helper'
require 'csv'

class TimeReportsControllerTest < ActionDispatch::IntegrationTest
  test 'creating a valid and trying to create an invalid time report' do
    successfully_import_a_time_report
    fail_to_upload_the_same_time_report_again
    download_a_csv_payroll_report
    view_a_json_payroll_report
  end

  private

  def successfully_import_a_time_report
    assert_difference('TimeLog.count', 32) { import_a_time_report }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div', 'Time report successfully saved.'
  end

  def fail_to_upload_the_same_time_report_again
    assert_difference('TimeLog.count', 0) { import_a_time_report }
    follow_redirect!
    assert_select 'div', 'A time report with this report id was already imported.'
  end

  def upload_an_empty_time_report
    assert_difference('TimeLog.count', 0) { upload_an_invalid_file_as_a_time_report }
    follow_redirect!
    assert_select 'div', 'File not uploaded, or invalid.'
  end

  def download_a_csv_payroll_report
    get payroll_report_url(format: :csv)
    assert_response :success
  end

  def view_a_json_payroll_report
    get payroll_report_url(format: :json)
    assert_response :success
  end

  ## helper methods below

  def import_a_time_report
    post time_reports_url,
         params: {
           time_report: {
             file: fixture_file_upload(
               Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
               'text/csv'
             )
           }
         }
  end

  def upload_an_invalid_file_as_a_time_report
    post time_reports_url,
         params: {
           time_report: 'Not a time report'
         }
  end
end
