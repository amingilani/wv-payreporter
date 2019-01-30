class CreateTimeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :time_logs do |t|
      t.date :date
      t.decimal :hours_worked
      t.integer :employee_id
      t.string :job_group
      t.integer :report_id

      t.timestamps
    end
  end
end
