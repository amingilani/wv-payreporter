# == Schema Information
#
# Table name: time_logs
#
#  id           :bigint(8)        not null, primary key
#  date         :date
#  hours_worked :decimal(, )
#  job_group    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  employee_id  :integer
#  report_id    :integer
#

class TimeLog < ApplicationRecord
end
