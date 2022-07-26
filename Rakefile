# frozen_string_literal: true

require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Default: run tests for all ORMs.'
task default: :tests

desc 'Run Devise tests for all ORMs.'
task :tests do
  Dir[File.join(File.dirname(__FILE__), 'test', 'orm', '*.rb')].each do |file|
    orm = File.basename(file).split('.').first

    if RUBY_VERSION >= '2.6.0'
      system("rake test DEVISE_ORM=#{orm}", exception: true)
    else
      system("rake test DEVISE_ORM=#{orm}")
      exit $?.exitstatus unless $?.success?
    end
  end
end
