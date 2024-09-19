# frozen_string_literal: true

require_relative "lib/email_tracker/version"

Gem::Specification.new do |spec|
  spec.name          = "custom_email_tracker"
  spec.version       = EmailTracker::VERSION
  spec.authors       = ["Bharat Bhushan"]
  spec.email         = ["mechathrust@gmail.com"]  # Replace with your email

  spec.summary       = "Email tracking for Rails applications."  # Short summary
  spec.description   = "A gem for tracking when emails are opened and links are clicked, allowing integration with ActionMailer in Rails apps."
  spec.homepage      = "https://github.com/believebhushan/email_tracker"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/believebhushan/email_tracker" 
  spec.metadata["changelog_uri"]   = "https://github.com/believebhushan/email_tracker/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir       = "exe"
  spec.executables  = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Add dependencies for the gem
  spec.add_dependency "rails", ">= 5.0"
  spec.add_dependency "nokogiri", ">= 1.11"  # For parsing and modifying email HTML content
end
