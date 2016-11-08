class ApplicationController < ActionController::API
  PAGE_TOKEN = 'EAASZBQhnIYvQBAFcIn7pbyLxsam6absGnOAA0UZAReTA7bgppLyRVAZAStaOssxGUlqSpEV48bwhj7MDvOrZAAZCqhhP9epbxWdhMktLmMm9u0qoiAPVx5ON1WH7gIJxR5G4blpWVdKEGqCZBACaayyZAqtdCEkelzMSrCnRVw4rwZDZD'

  def message
    text = params[:entry].try(:[], :messaging).try(:[], :message).try(:[], :text)
    recipient_id = params[:entry].try(:first).try(:[], :messaging).first.try(:[], :sender).try(:[], :id)

    connection = Faraday.new(
      url: 'https://graph.facebook.com/',
    )
    connection.post do |request|
      request.url('/v2.6/me/messages')
      request.params['access_token'] = PAGE_TOKEN
      request.headers['Content-Type'] = 'application/json'
      req.body = {
        recipient:{
          id: recipient_id,
        },
        message: {
          text: text,
        }
      }
    end

    head 200
  end

  # {
  #   "object"=>"page",
  #   "entry"=> [
  #     {
  #       "id"=>"1323532757671429",
  #       "time"=>1478582556893,
  #       "messaging"=>[
  #         {
  #           "sender"=>{
  #             "id"=>"1141243189291202"
  #           },
  #           "recipient"=>{
  #             "id"=>"1323532757671429"
  #           },
  #           "timestamp"=>1478582556765,
  #           "message"=>{
  #             "mid"=>"mid.1478582556765:0038074b75",
  #             "seq"=>7,
  #             "text"=>"hi"
  #           }
  #         }
  #       ]
  #     }
  #   ],
  #   "application"=>{
  #     "object"=>"page",
  #     "entry"=>[
  #       {
  #         "id"=>"1323532757671429",
  #         "time"=>1478582556893,
  #         "messaging"=>[
  #           {
  #             "sender"=>{
  #               "id"=>"1141243189291202"
  #             },
  #             "recipient"=>{
  #               "id"=>"1323532757671429"
  #             },
  #             "timestamp"=>1478582556765,
  #             "message"=>{
  #               "mid"=>"mid.1478582556765:0038074b75",
  #               "seq"=>7,
  #               "text"=>"hi"
  #             }
  #           }
  #         ]
  #       }
  #     ]
  #   }
  # }

  def verify
    mode = params['hub.mode']
    verify_token = params['hub.verify_token']
    challenge = params['hub.challenge']

    puts mode
    puts verify_token
    puts challenge

    if mode == 'subscribe' && verify_token == '417327'
      render json: challenge
    else
      head 401
    end
  end
end
