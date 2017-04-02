class ApplicationController < ActionController::API
  PAGE_TOKEN = 'EAASZBQhnIYvQBAFcIn7pbyLxsam6absGnOAA0UZAReTA7bgppLyRVAZAStaOssxGUlqSpEV48bwhj7MDvOrZAAZCqhhP9epbxWdhMktLmMm9u0qoiAPVx5ON1WH7gIJxR5G4blpWVdKEGqCZBACaayyZAqtdCEkelzMSrCnRVw4rwZDZD'


  RESPONSES_HASH = {
    'is nikhil stupid?' => 'Yes he is',
    'what is the meaning of the universe?' => '42',
    'toilet paper' => 'In the upstairs storage closet.',
    'bills' => 'Ask Victor',
    'fuck you' => 'No fuck you!'
  }

  # {
  #   "token" => "BOkRhXHS0tcxjeZEfsOHMEnU",
  #   "team_id" => "T2JTK19R7",
  #   "api_app_id" => "A4T7LAP6Y",
  #   "event"=> {
  #     "type"=>"message",
  #     "user"=>"U2K5X8VMH",
  #     "text"=>"bills",
  #     "ts"=>"1491099306.357268",
  #     "channel"=>"C4AGYTZFA",
  #     "event_ts"=>"1491099306.357268"
  #   },
  #   "type"=>"event_callback",
  #   "authed_users"=>["U2K5X8VMH"],
  #   "event_id"=>"Ev4TSW834P",
  #   "event_time"=>1491099306,
  #   "application"=>{
  #     "token"=>"BOkRhXHS0tcxjeZEfsOHMEnU",
  #     "team_id"=>"T2JTK19R7",
  #     "api_app_id"=>"A4T7LAP6Y",
  #     "event"=>{
  #       "type"=>"message",
  #       "user"=>"U2K5X8VMH",
  #       "text"=>"bills",
  #       "ts"=>"1491099306.357268",
  #       "channel"=>"C4AGYTZFA",
  #       "event_ts"=>"1491099306.357268"
  #     },
  #     "type"=>"event_callback",
  #     "authed_users"=>["U2K5X8VMH"],
  #     "event_id"=>"Ev4TSW834P",
  #     "event_time"=>1491099306
  #   }
  # }

  def message
    return head 200 if params[:event][:subtype] == 'bot_message'
    # This is nikhils rule
    # if params[:event][:user] == 'U2KDGT9V2'
    #   connection = Faraday.new(
    #     url: 'https://hooks.slack.com',
    #   )
    #   connection.post do |request|
    #     request.url('/services/T2JTK19R7/B4T7QKH52/2ZmMXsKBLHtuU7yZCgU3MCIQ')
    #     request.headers['Content-Type'] = 'application/json'
    #     request.body = { text: 'Nope' }.to_json
    #   end
    #
    #   return head 200
    # end

    text = params[:event].try(:[], :text)
    return head 200 unless response = RESPONSES_HASH[text.downcase]

    connection = Faraday.new(
      url: 'https://hooks.slack.com',
    )
    connection.post do |request|
      request.url('/services/T2JTK19R7/B4T7QKH52/2ZmMXsKBLHtuU7yZCgU3MCIQ')
      request.headers['Content-Type'] = 'application/json'
      request.body = { text: response }.to_json
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

    puts verify_token
    puts challenge

    render json: { challenge: challenge }
  end
end
