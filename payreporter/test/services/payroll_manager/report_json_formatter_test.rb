require 'test_helper'
require 'csv'

class ReportJsonFormatter < ActionDispatch::IntegrationTest
  EXPECTED = [
    {
      employee_id: 4,
      amount_paid: '$100.00',
      pay_period:  '16/2/2015 - 28/2/2015'
    }, {
      employee_id: 4,
      amount_paid: '$150.00',
      pay_period:  '16/2/2016 - 29/2/2016'
    }, {
      employee_id: 1,
      amount_paid: '$150.00',
      pay_period:  '1/11/2016 - 15/11/2016'
    }, {
      employee_id: 2,
      amount_paid: '$930.00',
      pay_period:  '1/11/2016 - 15/11/2016'
    }, {
      employee_id: 3,
      amount_paid: '$590.00',
      pay_period:  '1/11/2016 - 15/11/2016'
    }, {
      employee_id: 4,
      amount_paid: '$150.00',
      pay_period:  '1/11/2016 - 15/11/2016'
    }, {
      employee_id: 1,
      amount_paid: '$220.00',
      pay_period:  '16/11/2016 - 30/11/2016'
    }, {
      employee_id: 4,
      amount_paid: '$450.00',
      pay_period:  '16/11/2016 - 30/11/2016'
    }, {
      employee_id: 1,
      amount_paid: '$150.00',
      pay_period:  '1/12/2016 - 15/12/2016'
    }, {
      employee_id: 2,
      amount_paid: '$930.00',
      pay_period:  '1/12/2016 - 15/12/2016'
    }, {
      employee_id: 3,
      amount_paid: '$470.00',
      pay_period:  '1/12/2016 - 15/12/2016'
    }, {
      employee_id: 4,
      amount_paid: '$150.00',
      pay_period:  '1/12/2016 - 15/12/2016'
    }, {
      employee_id: 1,
      amount_paid: '$220.00',
      pay_period:  '16/12/2016 - 31/12/2016'
    }, {
      employee_id: 4,
      amount_paid: '$450.00',
      pay_period:  '16/12/2016 - 31/12/2016'
    }
  ].freeze

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
    actual = PayrollManager::ReportJsonFormatter.call payroll_report
    assert_equal EXPECTED, actual
  end
end
