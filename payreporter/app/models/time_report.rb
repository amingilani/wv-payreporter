# This is a tableless model

require 'csv'

class TimeReport
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serialization
  include ActiveModel::Lint::Tests
  extend ActiveModel::Callbacks

  define_model_callbacks :validation, :initialize

  after_initialize :set_vars
  before_validation :set_vars

  validate :report_should_not_already_exist
  validates :file, presence: true

  attr_accessor :file, :report_id

  def save
    raise ActiveModel::MissingAttributeError unless valid?

    TimeLog.transaction do
      csv.each do |record|
        time_log = record.to_h
        time_log[:wage] = (time_log['job_group'] == 'A' ? 20.to_money : 30.to_money)
        time_log.delete 'job_group'
        t = TimeLog.new time_log
        t.report_id = report_id
        t.save
      end
    end
    true
  rescue StandardError => error
    Rails.logger.warn error # I'm not in a real model, so I have to prepend Rails.
    false
  end

  # the raw CSV data from the file sans `report id`
  def csv
    CSV.parse(@csv_data, headers: true)
  end

  # extracts the `report id` from the file
  def set_report_id
    self.report_id = @report_id_line.match(/report id\,(.*),,/)[1]
  end

  private

  # a validation to ensure that the report id isn't already in the database
  def report_should_not_already_exist
    unless TimeLog.find_by(report_id: report_id).nil?
      errors
        .add(
          :report_id,
          'A time report with this report id was already imported.'
        )
    end
  end

  # sets the variables public methods will use to parse the data from the file
  def set_vars
    return unless @file

    @file = file
    @file.tempfile.open
    @file_lines = @file.tempfile.readlines
    @file.tempfile.close
    @file_lines[0] = @file_lines[0].tr(' ', '_')
    @report_id_line = @file_lines[-1]
    @csv_data = @file_lines[0...-1].join('')
    set_report_id
  end
end
