Rails.application.routes.draw do
  get '/email_open_tracker/:token', to: 'email_tracker/email_opens#track_open', as: :email_open_tracker
end