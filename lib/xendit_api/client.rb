require "base64"
require "faraday"
require "faraday_middleware"
require "json"

module XenditApi
	class Client
		attr_reader :token

    def initialize(api_key:)
    	@api_key = api_key
    	# Xendit requires us to use token in every request
    	# This is how to get the token, appending colon at the end then encode it
      @token = Base64.encode64(api_key + ':')
      setup_connection
    end

    def get_cash_balance
    	return nil if @api_key.empty?

			response = make_request('balance', 'get', {})

			attrs = JSON.parse(response.body)
      XenditApi::Entities::CashAccount.new(attrs)
    end
    
    def get_banks_for_disbursement
      return nil if @api_key.empty?

      response = make_request(
        'available_disbursements_banks', 'get'
      )

      elements = JSON.parse(response.body)
      banks = []

      elements.each do |element| 
        banks << XenditApi::Entities::Bank.new(element)
      end

      banks
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

      response = make_request('v2/invoices', 'post', data)

      attrs = JSON.parse(response.body)
      XenditApi::Entities::Invoice.new(attrs)
    end

    def get_disbursement(id:)
      return nil if @api_key.empty?

      path = 'v2/disbursements/' + id.to_s
      response = make_request(path, 'get')

      attrs = JSON.parse(response.body)
      XenditApi::Entities::Disbursement.new(attrs)
    end

    def create_disbursement(idempotency_key: nil, external_id:, bank_code:, account_holder_name:, account_number:, description:, amount:)
      return nil if @api_key.empty?

      data = { 
        external_id: external_id, 
        bank_code: bank_code, 
        account_holder_name: account_holder_name,
        account_number: account_number,
        description: description,
        amount: amount
      }

      if idempotency_key.nil?
        headers = {}
      else
        headers = { 'X-IDEMPOTENCY-KEY' => idempotency_key } 
      end

      response = make_request('disbursements', 'post', data, headers)

      attrs = JSON.parse(response.body)
      XenditApi::Entities::Disbursement.new(attrs)
    end

    def create_fixed_virtual_account(external_id:, bank_code:, name:, virtual_account_number:)
      return nil if @api_key.empty?

      data = { 
        external_id: external_id, 
        bank_code: bank_code, 
        name: name, 
        virtual_account_number: virtual_account_number
      }
      
      response = make_request('callback_virtual_accounts', 'post', data)

      attrs = JSON.parse(response.body)
      XenditApi::Entities::VirtualAccount.new(attrs)
    end

    def charge_credit_card(external_id:, token:, amount:)
      return nil if @api_key.empty?

      data = { 
        external_id: external_id, 
        token: token, 
        amount: amount
      }
      
      response = make_request('credit_card_charges', 'post', data)

      attrs = JSON.parse(response.body)
      XenditApi::Entities::CardCharge.new(attrs)
    end

    private

    def setup_connection
     # start setting up connections
      @connection = Faraday.new(url: XenditApi::BASE_URL) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.use FaradayMiddleware::RaiseHttpException
      end

      @connection.authorization(:Basic, @token)
      # finish setting up connection      
    end

    def make_request(endpoint, method, payload = {}, headers = {})
      # make the request for the transaction
      return @connection.post(endpoint, payload, headers) if method == 'post'

      @connection.get endpoint
    end
	end
end