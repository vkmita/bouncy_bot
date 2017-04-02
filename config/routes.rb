Rails.application.routes.draw do
  post '/message', to: 'application#message'
  post '/', to: 'application#verify'
end
