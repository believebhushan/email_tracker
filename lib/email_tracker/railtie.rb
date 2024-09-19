module EmailTracker
  class Railtie < Rails::Railtie
    initializer "email_tracker.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include EmailTracker::Tracker
      end
    end

    initializer "email_tracker.routes" do
      Rails.application.routes.append do
        get 'email_open_tracker/:token', to: 'email_tracker/email_opens#track_open', as: :email_open_tracker
      end
    end
  end
end