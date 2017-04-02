class ApplicationController < ActionController::API
  PAGE_TOKEN = 'EAASZBQhnIYvQBAFcIn7pbyLxsam6absGnOAA0UZAReTA7bgppLyRVAZAStaOssxGUlqSpEV48bwhj7MDvOrZAAZCqhhP9epbxWdhMktLmMm9u0qoiAPVx5ON1WH7gIJxR5G4blpWVdKEGqCZBACaayyZAqtdCEkelzMSrCnRVw4rwZDZD'


  RESPONSES_HASH = {
    'What is the meaning of the universe?' => '42',
    'toilet paper' => 'In the upstairs storage closet.',
    'bills' => 'Ask Victor'
  }

  def message
    text = params[:entry].first.try(:[], :messaging).first.try(:[], :message).try(:[], :text)
    recipient_id = params[:entry].try(:first).try(:[], :messaging).first.try(:[], :sender).try(:[], :id)

    connection = Faraday.new(
      url: 'https://graph.facebook.com/',
    )
    connection.post do |request|
      request.url('/v2.6/me/messages')
      request.params['access_token'] = PAGE_TOKEN
      request.headers['Content-Type'] = 'application/json'
      request.body = {
        recipient: {
          id: recipient_id,
        },
        message: {
          text: RESPONSES_HASH[text] || text,
        }
      }.to_json
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
    verify_token = params['token']
    challenge = params['challenge']

    puts mode
    puts verify_token
    puts challenge

    render json: challenge
  end
end
