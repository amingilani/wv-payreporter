require 'test_helper'

class PayrollReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payroll_report_index_url
    assert_response :success
  end

end
