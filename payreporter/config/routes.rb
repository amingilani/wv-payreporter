Rails.application.routes.draw do
  root 'payroll_report#index'
  resource :time_reports
end
