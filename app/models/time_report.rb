require 'csv'

# This is a tableless model, it parses CSV Time Reports and their individual Time Logs in the
# database
class TimeReport
  include ActiveModel::Model

  validate :report_should_not_already_exist
  validates :file, presence: true

  attr_reader :file, :report_id, :csv, :csv_raw

  def file=(file)
    @file = file.read
    @csv_raw = CSV.parse(@file, headers: true)
    @csv = @csv_raw[0..-2] # everything except the last row
    @report_id = @csv_raw[-1][1] # last raw, second column
  end

  def save
    raise ActiveModel::MissingAttributeError unless valid?

    TimeLog.transaction do
      @csv.each { |record| TimeLog.create process_line_to_timelog(record, @report_id) }
    end
    true
  rescue ActiveModel::MissingAttributeError => error
    Rails.logger.warn error # I'm not in a real model, so I have to prepend Rails.
    false
  end

  private

  def process_line_to_timelog(line, report_id)
    time_log = line.to_h.transform_keys { |e| e.parameterize.underscore.to_sym }
    time_log[:wage] = (time_log[:job_group] == 'A' ? 20.to_money : 30.to_money)
    time_log.delete :job_group
    time_log[:report_id] = report_id
    time_log
  end

  # rubocop:disable Style/GuardClause
  # a validation to ensure that the report id isn't already in the database
  def report_should_not_already_exist
    unless TimeLog.find_by(report_id: @report_id).nil?
      errors.add(:report_id,
                 'A time report with this report id was already imported.')
    end
  end
  # rubocop:enable Style/GuardClause
end
