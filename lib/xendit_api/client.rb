require "base64"

module XenditApi
	class Client
		attr_reader :token

    def initialize(api_key:)
    	# Xendit requires us to use token in every request
    	# This is how to get the token, appending colon at the end then encode it
      @token = Base64.encode64(api_key + ':')
    end		
	end
end