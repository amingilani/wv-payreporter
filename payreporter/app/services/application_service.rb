# This adds decorative methods that make calling service objects easier.
# For more documentation, please read my comprehensive post on Rails Service
# Objects: https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial

class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
