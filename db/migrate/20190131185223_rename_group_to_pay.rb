class RenameGroupToPay < ActiveRecord::Migration[5.2]
  def change
    remove_column :time_logs, :job_group
    add_monetize :time_logs, :wage
  end
end
