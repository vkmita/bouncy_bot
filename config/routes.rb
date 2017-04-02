Rails.application.routes.draw do
  post '/', to: 'application#message'
  # post '/', to: 'application#verify'
end
