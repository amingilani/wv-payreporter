require 'test_helper'
require 'csv'

class ReportJsonFormatter < ActionDispatch::IntegrationTest
  EXPECTED = [
    {
      start_date:  'Mon, 16 Feb 2015'.to_date,
      employee_id: 4,
      amount_paid: '$100.00',
      end_date:    'Sat, 28 Feb 2015'.to_date
    },
    {
      start_date:  'Tue, 16 Feb 2016'.to_date,
      employee_id: 4,
      amount_paid: '$150.00',
      end_date:    'Mon, 29 Feb 2016'.to_date
    },
    {
      start_date:  'Tue, 01 Nov 2016'.to_date,
      employee_id: 1,
      amount_paid: '$150.00',
      end_date:    'Tue, 15 Nov 2016'.to_date
    },
    {
      start_date:  'Tue, 01 Nov 2016'.to_date,
      employee_id: 2,
      amount_paid: '$930.00',
      end_date:    'Tue, 15 Nov 2016'.to_date
    },
    {
      start_date:  'Tue, 01 Nov 2016'.to_date,
      employee_id: 3,
      amount_paid: '$590.00',
      end_date:    'Tue, 15 Nov 2016'.to_date
    },
    {
      start_date:  'Tue, 01 Nov 2016'.to_date,
      employee_id: 4,
      amount_paid: '$150.00',
      end_date:    'Tue, 15 Nov 2016'.to_date
    },
    {
      start_date:  'Wed, 16 Nov 2016'.to_date,
      employee_id: 1,
      amount_paid: '$220.00',
      end_date:    'Wed, 30 Nov 2016'.to_date
    },
    {
      start_date:  'Wed, 16 Nov 2016'.to_date,
      employee_id: 4,
      amount_paid: '$450.00',
      end_date:    'Wed, 30 Nov 2016'.to_date
    },
    {
      start_date:  'Thu, 01 Dec 2016'.to_date,
      employee_id: 1,
      amount_paid: '$150.00',
      end_date:    'Thu, 15 Dec 2016'.to_date
    },
    {
      start_date:  'Thu, 01 Dec 2016'.to_date,
      employee_id: 2,
      amount_paid: '$930.00',
      end_date:    'Thu, 15 Dec 2016'.to_date
    },
    {
      start_date:  'Thu, 01 Dec 2016'.to_date,
      employee_id: 3,
      amount_paid: '$470.00',
      end_date:    'Thu, 15 Dec 2016'.to_date
    },
    {
      start_date:  'Thu, 01 Dec 2016'.to_date,
      employee_id: 4,
      amount_paid: '$150.00',
      end_date:    'Thu, 15 Dec 2016'.to_date
    },
    {
      start_date:  'Fri, 16 Dec 2016'.to_date,
      employee_id: 1,
      amount_paid: '$220.00',
      end_date:    'Sat, 31 Dec 2016'.to_date
    },
    {
      start_date:  'Fri, 16 Dec 2016'.to_date,
      employee_id: 4,
      amount_paid: '$450.00',
      end_date:    'Sat, 31 Dec 2016'.to_date
    }
  ].freeze

  test 'creating a valid and trying to create an invalid time report' do
    post time_reports_url,
         params: {
           file: fixture_file_upload(
             Rails.root.join('test', 'fixtures', 'files', 'sample.csv'),
             'text/csv'
           )
         }
    payroll_report = PayrollManager::Reporter.call
    actual = PayrollManager::ReportJsonFormatter.call payroll_report
    assert_equal EXPECTED, actual
  end
end
