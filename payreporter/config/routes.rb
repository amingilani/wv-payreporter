Rails.application.routes.draw do
  root 'payroll_report#index'
  get 'payroll_report', to: 'payroll_report#index', defaults: { format: 'json' }

  resource :time_reports
end
