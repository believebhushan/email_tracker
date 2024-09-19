require "custom_email_tracker/version"
require "custom_email_tracker/tracker"
require 'custom_email_tracker/engine'

module CustomEmailTracker

  class MigrationCreator
    def self.create_migration_file
      migration_version = ActiveRecord::Migration.current_version
      migration_content = <<-RUBY
      class CreateTrackedEmails < ActiveRecord::Migration[#{migration_version}]
        def change
          create_table :tracked_emails do |t|
            t.string :token, null: false
            t.datetime :opened_at
            t.string :to_email
            t.string :mailer_class
            t.string :mailer_action
      
            t.timestamps
          end
        end
      end      
      RUBY

      timestamp = Time.current.strftime('%Y%m%d%H%M%S')
      migration_filename = "db/migrate/#{timestamp}_create_tracked_emails.rb"

      File.open(migration_filename, 'w') do |file|
        file.write(migration_content)
      end

      puts "Migration file created at #{migration_filename}"

      email_template_content = <<-RUBY
        
        <% unless @avoid_tracking %>
          <%
          new_tracked_email = TrackedEmail.track_new(message.to.first, message.delivery_handler, action_name)
          %>
          <% if new_tracked_email.present? %>
              <%= new_tracked_email[:image] %>
          <% end %>
        <% end %>
      RUBY
    
      mailer_layout_file_name = Rails.root.join('app', 'views', 'layouts', 'mailer.html.erb')
      
      if File.exist?(mailer_layout_file_name)
        File.open(mailer_layout_file_name, 'a') do |file|
          file.write(email_template_content)
        end
        puts "Content successfully appended to #{mailer_layout_file_name}"
      else
        puts "The file #{mailer_layout_file_name} does not exist. Please add the following content manually:"
        puts email_template_content
      end
    end

  end

end
