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

			response = make_request('balance', 'get', {})

			attrs = JSON.parse(response.body)
      XenditApi::Entities::CashAccount.new(attrs)
    end

    def get_bank_account_data(account_number:, bank_code:)
      return nil if @api_key.empty?

      response = make_request(
        'bank_account_data_requests', 
        'post', 
        { bank_account_number: account_number, bank_code: bank_code }
      )

      JSON.parse(response.body)
    end

    def get_invoice(id:)
      return nil if @api_key.empty?

      path = 'v2/invoices/' + id.to_s
      response = make_request(path, 'get')

      attrs = JSON.parse(response.body)
      XenditApi::Entities::Invoice.new(attrs)
    end

    def create_invoice(external_id:, payer_email:, description:, amount:)
      return nil if @api_key.empty?

      data = { 
        external_id: external_id, 
        payer_email: payer_email, 
        description: description, 
        amount: amount
      }
      
      response = make_request('v2/invoices/', 'post', data)

      attrs = JSON.parse(response.body)
      XenditApi::Entities::Invoice.new(attrs)
    end

    private

    def make_request(endpoint, method, payload = {})
      # start setting up connections
      @connection = Faraday.new(url: XenditApi::BASE_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
			
			@connection.token_auth @token 
      # finish setting up connection

      # make the request for the transaction
      if method == 'post'
        @connection.post do |req|
          req.url endpoint
          req.body = payload
        end
      else
        @connection.get endpoint      
      end
    end
	end
end