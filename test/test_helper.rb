ENV["RAILS_ENV"] = "test"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym

$:.unshift File.dirname(__FILE__)
puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"
require "rails_app/config/environment"
include Devise::TestHelpers
require "orm/#{DEVISE_ORM}"
require 'rails/test_help'
require 'capybara/rails'
if Rails.version < '4'
  require 'capybara-screenshot/testunit'
else
  require 'capybara-screenshot/minitest'
end
require 'timecop'

I18n.load_path << File.expand_path("../support/locale/en.yml", __FILE__) if DEVISE_ORM == :mongoid

ActiveSupport::Deprecation.silenced = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
class ActionController::TestCase
  include Devise::TestHelpers
end
