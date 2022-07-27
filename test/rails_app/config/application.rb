require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

begin
  require "#{DEVISE_ORM}/railtie"
rescue LoadError
end

PARENT_MODEL_CLASS = DEVISE_ORM == :active_record ? ActiveRecord::Base : Object

require "devise"
require "devise_google_authenticator"

ActiverecordMigrationKlass = if Rails.version >= '5.1'
                               ActiveRecord::Migration[4.2]
                             else
                               ActiveRecord::Migration
                             end

module RailsApp
  class Application < Rails::Application
    #config.filter_parameters << :password

    if Rails.version >= '5.2'
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end
  end
end
