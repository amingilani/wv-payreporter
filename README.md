# PayReporter

This is a solution to Wave's [se-challenge-payroll](https://github.com/wvchallenges/se-challenge-payroll) challenge. This application goes beyond the challenge outlined in the assignment and goes beyond the initial requirement.

Please note, while this application remains easy to review, some of the design decisions were optimized to show off my skills and would not reflect decisions I'd usually take while building an MVP. E.g. I could have either used only service objects or only tableless models. Instead, to show off my ability in each, I used both service objects and created a tableless model.

Key features:

+ 99%+ test coverage
+ Automatic model annotations
+ Automatic Entity Relationship Diagram generation (`erd.pdf`)
+ Tableless models
+ Service objects
+ Payroll Report available as:
  + Human friendly view
  + Printer friendly view
  + JSON API
  + CSV download
+ Haml views
+ Custom Rubocop config
+ Beautiful code, if I say so myself
+ [`money`](https://github.com/Rubymoney/money) gem to handle monetary values

## Application

Let's walk over key parts of the application. The `schema.rb` only defines one important table, since a "Time Report" is probably a collection of Time Logs, that's what the table is:

![TimeLog schema](timelog.png)

### Models

* `app/models/time_log.rb`: The `money_rails` gem combines the `wage_cents` and `wage_currency` fields into a `wage` attribute that produces a [`money`](https://github.com/Rubymoney/money) instance.
* `app/models/time_report.rb`: A tableless model that processes the non-standard Time Report CSV files and saves them as `TimeLog`s.

### Controllers

* `time_reports_controller.rb`: This saves `TimeReport`s and redirect back to the `root_path`, along with some `flash` messages.
* `payroll_report_controller.rb`: Depending on the `format`, or `params[:printer]` value, it renders:
  + a human friendly Payroll Report
  + a printer friendly Payroll Report
  + a CSV printer report for download
  + a JSON version of the Payroll Report

### Services

Every service object in `app/services/` does one specific thing only, and is named boringly after its role. To learn more, please read my article [_Rails Service Objects: A Comprehensive Guide_](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial) on the Toptal blog.

  * `application_service.rb`: Contains shared decorative methods
  * `payroll_manager/reporter.rb`: Runs a SQL query to obtain the data required to build a Payroll Report
  + `payroll_manager/report_json_formatter.rb`: Formats a Payroll Reports from the `PayrollManager::Reporter` to JSON
  + `payroll_manager/report_csv_formatter.rb`: Formats a Payroll Reports from the `PayrollManager::Reporter` to CSV

### Views

I prefer HAML because I don't like typing.

* `app/views/layouts/application.html.haml`: the layout only renders the body and, two partials:
  * `_header.html.haml`: is rendered before pages, contains the header that runs across the top of the page, and loads stylesheets with subresource integrity
  * `_footer.html.haml`: is rendered after pages, loads external javascript with subresource integrity, and contains some custom JavaScript.
* `app/views/payroll_report/index.html.haml`: This renders the index page, and depending on the of `@printer` passed onto it by the controller renders one of two partials:
  * `_human_friendly_report.html.haml`: A human friendly version of the Payroll Report
  * `_printer_friendly_report.html.haml`: A printer friendly version of the Payroll Report

## Evaluation

Evaluation of your submission will be based on the following criteria.

1. Did you follow the instructions for submission?  **Yes, or I will when I submit this.**
1. Did you document your build/deploy instructions and your explanation of what
   you did well?
1. Were models/entities and other components easily identifiable to the
   reviewer? **Yes. I've documented everything, so they should be.**
1. What design decisions did you make when designing your models/entities? Are they explained? **I used a tableless model and service objects, as well as raw SQL queries instead of ActiveRecord/Arel queries or even mapping through the data in memory. Justification for these is given in more detail above**
1. Did you separate any concerns in your application? Why or why not? **No, this app wasn't complicated enough to require shared logic. Infact, no controllers or models share any logic**
1. Does your solution use appropriate data types for the problem as described? **Data-types weren't described. I inferred them, and this question made me feel like you _wanted_ me to use an integer for Report IDs. In real life, however, I would've used a string because they're meta properties the user supplied, and one user's Report IDs data-type don't necessarily have to match another's**
