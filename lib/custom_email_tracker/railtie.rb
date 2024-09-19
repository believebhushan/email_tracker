module CustomEmailTracker
  class Railtie < Rails::Railtie
    initializer "custom_email_tracker.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include CustomEmailTracker::Tracker
      end
    end

    initializer "custom_email_tracker.routes" do
      Rails.application.routes.append do
        get 'email_open_tracker/:token', to: 'custom_email_tracker/email_opens#track_open', as: :email_open_tracker
      end
    end
  end
end