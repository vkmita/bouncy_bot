class ApplicationController < ActionController::API
  def message
    'Hello world'
  end

  def verify
    mode = params['hub.mode']
    verify_token = params['hub.verify_token']
    challenge = params['hub.challenge']

    puts mode
    puts verify_token
    puts challenge

    if mode == 'subscribe' && verify_token == '417327'
      render json: 'challenge'
    else
      head 401
    end
  end
end
