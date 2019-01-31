# == Schema Information
#
# Table name: time_logs
#
#  id            :bigint(8)        not null, primary key
#  date          :date
#  hours_worked  :decimal(, )
#  wage_cents    :integer          default(0), not null
#  wage_currency :string           default("CAD"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  employee_id   :integer
#  report_id     :integer
#

require 'test_helper'

class TimeLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
