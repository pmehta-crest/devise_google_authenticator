if ENV.fetch('CI', nil)
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.logger = Logger.new(nil)
end

ActiveRecord::Migrator.migrate(File.expand_path("../../rails_app/db/migrate/", __FILE__))
