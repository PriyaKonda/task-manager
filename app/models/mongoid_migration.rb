class MongoidMigration
  include Mongoid::Document
  
  field :version, type: String
  field :migrated_at, type: Time, default: -> { Time.current }
  
  index({ version: 1 }, { unique: true })
  
  class << self
    def migrate
      pending_migrations.each do |migration|
        puts "Running migration: #{migration[:version]} - #{migration[:name]}"
        migration[:class].new.up
        create!(version: migration[:version])
        puts "Completed migration: #{migration[:version]}"
      end
      puts "All migrations completed"
    end
    
    def rollback(steps = 1)
      last_migrations = desc(:migrated_at).limit(steps)
      last_migrations.each do |migration_record|
        migration = find_migration_by_version(migration_record.version)
        if migration
          puts "Rolling back: #{migration[:version]} - #{migration[:name]}"
          migration[:class].new.down
          migration_record.destroy
          puts "Rolled back: #{migration[:version]}"
        end
      end
    end
    
    def status
      puts "Migration Status:"
      puts "=================="
      all_migrations.each do |migration|
        status = migrated?(migration[:version]) ? "UP" : "DOWN"
        puts "#{status.ljust(6)} #{migration[:version]} #{migration[:name]}"
      end
    end
    
    private
    
    def pending_migrations
      all_migrations.reject { |m| migrated?(m[:version]) }
    end
    
    def migrated?(version)
      exists?(version: version)
    end
    
    def all_migrations
      Dir[Rails.root.join('db/migrate/*.rb')].map do |file|
        filename = File.basename(file, '.rb')
        version = filename.split('_').first
        name = filename.gsub(/^\d+_/, '').humanize
        class_name = filename.camelize
        require file
        {
          version: version,
          name: name,
          class: class_name.constantize,
          file: file
        }
      end.sort_by { |m| m[:version] }
    end
    
    def find_migration_by_version(version)
      all_migrations.find { |m| m[:version] == version }
    end
  end
end