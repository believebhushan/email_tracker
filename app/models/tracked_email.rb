class TrackedEmail < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  before_validation :generate_token, on: :create

  # Embeds an invisible 1x1 tracking pixel in the email body
  def self.generate_tracking_pixel(token)
    "<img src='#{tracking_url(token)}' alt='' style='display:none;'>".html_safe
  end

  # Tracks a new email based on the provided parameters
  def self.track_new(to_email = "", mailer_class = "", mailer_action = "", token = "")
    if token.present?
      tracked_email = TrackedEmail.find_or_initialize_by(token: token)
      
      # Return if the tracked email already exists
      if tracked_email.id.present?
        return {
          tracking_id: tracked_email.id,
          token: tracked_email.token,
          status: false,
          message: "Already There",
          image: generate_tracking_pixel(tracked_email.token)
        }
      end

      # Create and save the tracked email
      tracked_email.to_email = to_email if to_email.present?
      tracked_email.mailer_class = mailer_class if mailer_class.present?
      tracked_email.mailer_action = mailer_action if mailer_action.present?
      tracked_email.save
      
      # Return after saving the new record
      return {
        tracking_id: tracked_email.id,
        token: tracked_email.token,
        status: true,
        message: "Created Successfully",
        image: generate_tracking_pixel(tracked_email.token)
      } if tracked_email.id.present?
    end

    # Handle case where no token is provided
    tracked_email = TrackedEmail.new()
    tracked_email.to_email = to_email if to_email.present?
    tracked_email.mailer_class = mailer_class if mailer_class.present?
    tracked_email.mailer_action = mailer_action if mailer_action.present?
    tracked_email.save

    # Return after creating a new tracked email
    return {
      tracking_id: tracked_email.id,
      token: tracked_email.token,
      status: true,
      message: "Created Successfully",
      image: generate_tracking_pixel(tracked_email.token)
    } if tracked_email.id.present?
  end

  # Generates the URL where email opens will be tracked
  def self.tracking_url(token)
    Rails.application.routes.url_helpers.email_open_tracker_url(token: token)
  end

  private

  def generate_token
    return if token.present?

    loop do
      @token = Time.now.to_i.to_s + SecureRandom.hex(64 / 8).upcase
      break @token unless TrackedEmail.exists?(token: @token)
    end
    self.token = @token
  end
end
