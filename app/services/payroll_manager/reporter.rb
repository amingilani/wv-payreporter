module PayrollManager
  # This service class returns the formatted data as required by the assignment.
  # It lets the database do most of the heavy lifting leaving the application
  # memory free on non-resource intensive tasks
  # Use like so: a = PayReporter.call
  class Reporter < ApplicationService
    # I'm using a raw SQL query because Active Record or even Arel doesn't allow
    # advanced queries that typecast or allow data manipulation to such a degree.
    # The Subquery:
    # (1) multiplies hours_worked with wage_cents giving us the amount_paid_cents,
    # and (2) using some clever rounding and typecasting, gives us the start_date for the pay period
    # which is enough information for us to infer the period's ending date later, in our application
    # The remaining query:
    # Sums the amount_paid_cents for employees with multiple TimeLogs in the same Pay Period
    # (proxied by the start_date), and then sorts first by start_date and employee_id
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

    # Format the SQL result to resemble the final Payroll Report required
    def decoration(raw_pay_report:)
      raw_pay_report.map do |e|
        e = e.symbolize_keys
        e[:amount_paid] = (e[:amount_paid_cents].to_money / 100)
        e[:start_date] = e[:start_date].to_date
        e[:end_date] = e[:start_date].day > 15 ? e[:start_date].end_of_month : e[:start_date].beginning_of_month + 14
        e[:pay_period] = "#{e[:start_date].strftime('%-d/%-m/%Y')} - #{e[:end_date].strftime('%-d/%-m/%Y')}"
        %i[amount_paid_cents start_date end_date].each { |k| e.delete(k) }
        e
      end
    end
  end
end
