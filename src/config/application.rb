require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

module DocuSeal
  class Application < Rails::Application
    config.load_defaults 7.1
    
    # Configuration for the application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :en
    
    # Don't generate system test files
    config.generators.system_tests = nil
    
    # Configure sensitive parameters which will be filtered from the log file
    config.filter_parameters += [:passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn]
  end
end 