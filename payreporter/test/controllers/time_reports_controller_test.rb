require 'test_helper'

class TimeReportsControllerTest < ActionDispatch::IntegrationTest
  test 'creating a valid and trying to create an invalid time report' do
    assert_difference 'TimeLog.count', 32 do
      post time_reports_url,
           params: {
             file: fixture_file_upload(
               Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
               'text/csv'
             )
           }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div', 'Time report successfully saved.'

    assert_difference 'TimeLog.count', 0 do
      post time_reports_url,
           params: {
             file: fixture_file_upload(
               Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
               'text/csv'
             )
           }
    end
    follow_redirect!
    assert_select 'div', 'A time report with this report id was already imported.'
  end
end
