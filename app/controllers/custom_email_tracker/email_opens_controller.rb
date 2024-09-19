module CustomEmailTracker
  class EmailOpensController < ActionController::Base
    def track_open
      token = params[:token]

      email_open = TrackedEmail.find_by(token: token)
      if email_open.present?
        email_open.opened_at = Time.zone.now
        email_open.save
      end


      # Serve a 1x1 pixel image
      # send_file Rails.root.join('app/assets/images/pixel.png'), type: 'image/png', disposition: 'inline'

      pixel_image_path = File.join(__dir__, 'pixel.png')

      if File.exist?(pixel_image_path)
        send_file pixel_image_path, type: 'image/png', disposition: 'inline'
      else
        render plain: "Image not found", status: :ok
      end
      
    end
  end
end