module PayrollManager
  # This service class returns the formatted data as required by the assignment.
  # It lets the database do most of the heavy lifting leaving the application
  # memory free on non-resource intensive tasks
  # Use like so: a = PayReporter.call
  class Reporter < ApplicationService
    # I'm using a raw SQL query because Active Record or even Arel doesn't allow
    # advanced queries that typecast or allow data manipulation to such a degree
    SQL_QUERY = <<~HEREDOC.freeze
      SELECT start_date,
             SUM(amount_paid_cents) amount_paid_cents,
             employee_id
      FROM
        (SELECT *, date, (hours_worked * wage_cents) AS amount_paid_cents,
                         CASE
                             WHEN EXTRACT(DAY
                                          FROM date)>15 THEN TO_CHAR(date, 'yyyy-mm-16')::date
                             ELSE TO_CHAR(date, 'yyyy-mm-01')::date
                         END AS start_date
         FROM time_logs) AS subquery
      GROUP BY subquery.employee_id,
               subquery.start_date
      ORDER BY start_date,
               employee_id;
    HEREDOC

    def call
      raw_pay_report = ActiveRecord::Base.connection.execute(SQL_QUERY)
      decoration(raw_pay_report: raw_pay_report)
    end

    private

    def decoration(raw_pay_report:)
      raw_pay_report.map do |e|
        e = e.symbolize_keys
        e[:amount_paid] = (e[:amount_paid_cents].to_money / 100)
        e[:start_date] = e[:start_date].to_date
        e[:end_date] = e[:start_date].day > 15 ? e[:start_date].end_of_month : e[:start_date].beginning_of_month + 14
        e.delete(:amount_paid_cents)
        e
      end
    end
  end
end
