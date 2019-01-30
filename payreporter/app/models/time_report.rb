# This is a tableless model

require 'csv'

class TimeReport
  attr_accessor :file

  def initialize(file:)
    @file = file
    @file_lines = @file.tempfile.readlines
    @file_lines[0] = @file_lines[0].gsub(' ', '_')
    @report_id_line =  @file_lines[-1]
    @csv_data = @file_lines[0...-1].join('')
  end

  def save
    TimeLog.transaction do
      csv.each do |record|
        t = TimeLog.new record.to_h
        t.report_id = report_id
        t.save
      end
    end
    true
    # TODO: Add failure branch
  end

  def csv
    CSV.parse(@csv_data, headers: true)
  end

  def report_id
    @report_id_line.match(/report id\,(.*),,/)[1]
  end
end
