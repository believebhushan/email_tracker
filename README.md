
![CustomEmailTracker Logo](https://repository-images.githubusercontent.com/859835840/76fa9ee4-f229-4ec7-bf32-450e756a1095)

# CustomEmailTracker

Welcome to the CustomEmailTracker gem! This gem provides email tracking functionality for Rails applications, allowing you to track when emails are opened and when links within emails are clicked. It integrates seamlessly with ActionMailer to enhance your email interactions and analytics.

## Installation


Add the gem to your application's Gemfile:

```ruby
gem 'custom_email_tracker', '~> 0.1.2'
```

Then run:

```bash
$ bundle install
```

Or install it directly using:

```bash
$ gem install custom_email_tracker -v '0.1.2'
```

## Setup

### 1. Run the Migration

First, ensure your Rails console is running:

```bash
$ rails c
```

Then, create the necessary migration file for your database and update your mailer views by running:

```ruby
CustomEmailTracker::MigrationCreator.create_migration_file
```

This method will:
- Generate a migration file to create a `tracked_emails` table in your database. This table will store information about tracked emails including tokens, timestamps, and other relevant details.
- Append necessary tracking code to your mailer layout file (`mailer.html.erb`) to insert a tracking pixel in your email views. If this file does not exist, you will need to manually add the provided content.

After running the migration creator, apply the migration to your database:

```bash
$ rails db:migrate
```

### 2. Configure Your Environment

Add the following configurations to your environment files:

#### Development

In `config/environments/development.rb`:

```ruby
Rails.application.routes.default_url_options[:host] = 'localhost'
Rails.application.routes.default_url_options[:port] = PORT
```

#### Production

In `config/environments/production.rb`:

```ruby
Rails.application.routes.default_url_options[:host] = 'domain-name.com'
```

Replace `'domain-name.com'` with your actual domain name.

## Usage

### Tracking Email Openings

1. **Add Tracking Pixel to Emails:**

   If your mailer layout file (`mailer.html.erb`) exists, the tracking code should already be appended. If it does not exist, you need to manually add the following code to your mailer views where you want to track email openings:

   ```erb
   <% unless @avoid_tracking %>
     <%
     new_tracked_email = TrackedEmail.track_new(message.to.first, message.delivery_handler, action_name)
     %>
     <% if new_tracked_email.present? %>
         <%= new_tracked_email[:image] %>
     <% end %>
   <% end %>
   ```

2. **Handling Missing Mailer Layout File:**

   If your `mailer.html.erb` file does not exist, you can create one in `app/views/layouts/` and add the tracking code snippet mentioned above.

### Tracking Link Clicks

Ensure that all links in your emails are wrapped with the tracking helper:

```erb
<%= custom_email_tracker_link_to 'Link Text', link_url %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run:

```bash
$ bundle exec rake install
```

To release a new version, update the version number in `lib/custom_email_tracker/version.rb`, and then run:

```bash
$ bundle exec rake release
```

This will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/believebhushan/email_tracker](https://github.com/believebhushan/email_tracker). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/believebhushan/email_tracker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomEmailTracker project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/believebhushan/email_tracker/blob/master/CODE_OF_CONDUCT.md).

---

### Explanation of `track_new` Method

The `track_new` method is designed to manage the tracking of email openings. Here’s how it works:

1. **Creating or Finding a Tracked Email:**
   The method looks for an existing `TrackedEmail` record with the provided token. If the token is present and a record with this token is found, it returns the tracking pixel and status indicating that the record already exists.

2. **Creating a New Tracked Email:**
   If no record with the given token is found, a new `TrackedEmail` record is created with the provided email address, mailer class, and action. The tracking pixel is generated and returned.

3. **Handling Missing Tokens:**
   If no token is provided, a new `TrackedEmail` is created with the provided email and action details, and a tracking pixel is returned.

The `generate_tracking_pixel` method is used to generate an invisible tracking pixel embedded in the email body. The pixel's URL includes the unique token, allowing the application to track when the email is opened.

Feel free to adjust the content as needed!
