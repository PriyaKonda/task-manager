namespace :db do
  namespace :mongoid do
    desc "Create the database"
    task :create => :environment do
      # MongoDB creates databases automatically when first accessed
      puts "MongoDB database will be created automatically on first use"
    end

    desc "Drop the database"
    task :drop => :environment do
      Mongoid.purge!
      puts "Dropped database for #{Mongoid.default_client.database.name}"
    end

    desc "Run migrations"
    task :migrate => :environment do
      MongoidMigration.migrate
    end

    desc "Rollback migrations"
    task :rollback => :environment do
      MongoidMigration.rollback
    end

    desc "Show migration status"
    task :status => :environment do
      MongoidMigration.status
    end

    desc "Seed the database"
    task :seed => :environment do
      load Rails.root.join('db', 'seeds.rb')
    end
  end
end