require "base64"
require "faraday"
require "json"

module XenditApi
	class Client
		attr_reader :token

    def initialize(api_key:)
    	@api_key = api_key
    	# Xendit requires us to use token in every request
    	# This is how to get the token, appending colon at the end then encode it
      @token = Base64.encode64(api_key + ':')
    end

    def get_cash_balance
    	return nil if @api_key.empty?

			response = make_request('balance', {})

			JSON.parse(response.body)
    end

    private

    def make_request(endpoint, payload = {})
      # start setting up connections
      @connection = Faraday.new(url: XenditApi::BASE_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
			
			@connection.token_auth @token 
      # finish setting up connection

      # make the request for the transaction
      @connection.post do |req|
        req.url endpoint
        req.body = payload
      end      	
    end
	end
end