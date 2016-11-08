Rails.application.routes.draw do
  post '/', to: 'application#message'
  get '/', to: 'application#verify'
end
