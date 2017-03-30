require 'spec_helper'

module XenditApi
  describe Client do
    it 'takes an API key on initialization and convert it into token' do
      require "base64"
      api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='

      client = Client.new(api_key: api_key)

      appended_api_key = api_key + ':'
      tokenized_api_key = Base64.strict_encode64(appended_api_key)

      expect(client.token).to eq tokenized_api_key 
    end

    describe '.get_balance' do
      context 'valid request' do
        before do
          @stub = stub_request(:get, "https://api.xendit.co/balance")
            .to_return(:status => 200, :body => '{"balance": 1241231}', :headers => {})          
        end

        it 'should return the current balance of the merchant account' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_cash_balance 

          expect(result.balance).to eq 1241231
          expect(result.balance_cents).to eq 124123100
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_cash_balance 

          expect(result).to eq nil
        end
      end    
    end

    describe '.get_invoice' do
      context 'valid request' do
        before do
          data = read_file_fixture('invoice.json')
          @parsed_data = JSON.parse(data)
          @stub = stub_request(:get, "https://api.xendit.co/v2/invoices/" + @parsed_data['id'])
            .to_return(:status => 200, :body => data, :headers => {})     
        end

        it 'should return the invoice fetched by the id' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_invoice(id: @parsed_data['id'])

          expect(result.class.name).to eq 'XenditApi::Entities::Invoice'
          expect(result.amount).to eq @parsed_data['amount']
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_invoice(id: 'random_id')

          expect(result).to eq nil
        end
      end    
    end

    describe '.create_invoice' do
      let(:data) { read_file_fixture('invoice.json') }
      let(:parsed_data) { JSON.parse(data) }

      context 'valid request' do
        before do          
          @stub = stub_request(:post, "https://api.xendit.co/v2/invoices")
            .to_return(:status => 201, :body => data, :headers => {})     
        end

        it 'should return the invoice created by the request' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.create_invoice(
            external_id: parsed_data['external_id'], 
            payer_email: parsed_data['payer_email'], 
            description: parsed_data['description'], 
            amount: parsed_data['amount']
          )

          expect(result.class.name).to eq 'XenditApi::Entities::Invoice'
          expect(result.amount).to eq parsed_data['amount']
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.create_invoice(
            external_id: parsed_data['external_id'], 
            payer_email: parsed_data['payer_email'], 
            description: parsed_data['description'], 
            amount: parsed_data['amount']
          )          

          expect(result).to eq nil
        end
      end    
    end

    describe '.create_fixed_virtual_account' do
      let(:data) { read_file_fixture('virtual_account.json') }
      let(:parsed_data) { JSON.parse(data) }

      context 'valid request' do
        before do          
          @stub = stub_request(:post, "https://api.xendit.co/callback_virtual_accounts")
            .to_return(:status => 201, :body => data, :headers => {})     
        end

        it 'should return the virtual_account created by the request' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.create_fixed_virtual_account(
            external_id: parsed_data['external_id'], 
            bank_code: parsed_data['bank_code'], 
            name: parsed_data['name'], 
            virtual_account_number: parsed_data['account_number']
          )

          expect(result.class.name).to eq 'XenditApi::Entities::VirtualAccount'
          expect(result.account_number).to eq parsed_data['account_number']
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.create_fixed_virtual_account(
            external_id: parsed_data['external_id'], 
            bank_code: parsed_data['bank_code'], 
            name: parsed_data['name'], 
            virtual_account_number: parsed_data['account_number']
          )        

          expect(result).to eq nil
        end
      end    
    end

    describe '.create_disbursement' do
      let(:data) { read_file_fixture('disbursement.json') }
      let(:parsed_data) { JSON.parse(data) }

      context 'valid request' do
        before do          
          @stub_with_header = stub_request(:post, "https://api.xendit.co/disbursements")
            .with(headers:{ 'X-IDEMPOTENCY-KEY' => 'uniqueUID' })          
            .to_return(:status => 201, :body => data, :headers => {})

          @stub_without_header = stub_request(:post, "https://api.xendit.co/disbursements")
            .to_return(:status => 201, :body => data, :headers => {})                 
        end

        it 'should be able to create disbursement with idempotency_key' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.create_disbursement(
            idempotency_key: 'uniqueUID',
            external_id: parsed_data['external_id'], 
            bank_code: parsed_data['bank_code'], 
            account_holder_name: parsed_data['account_holder_name'], 
            account_number: parsed_data['account_number'],
            description: parsed_data['description'],
            amount: parsed_data['amount']
          )

          expect(result.class.name).to eq 'XenditApi::Entities::Disbursement'
          expect(result.amount).to eq parsed_data['amount']
          expect(@stub_with_header).to have_been_requested
        end

        it 'is also valid to create disbursement WITHOUT idempotency_key' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.create_disbursement(
            external_id: parsed_data['external_id'], 
            bank_code: parsed_data['bank_code'], 
            account_holder_name: parsed_data['account_holder_name'], 
            account_number: parsed_data['account_number'],
            description: parsed_data['description'],
            amount: parsed_data['amount']
          )

          expect(result.class.name).to eq 'XenditApi::Entities::Disbursement'
          expect(result.amount).to eq parsed_data['amount']
          expect(@stub_without_header).to have_been_requested
          expect(@stub_with_header).to_not have_been_requested
        end        
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.create_disbursement(
            external_id: parsed_data['external_id'], 
            bank_code: parsed_data['bank_code'], 
            account_holder_name: parsed_data['account_holder_name'], 
            account_number: parsed_data['account_number'],
            description: parsed_data['description'],
            amount: parsed_data['amount']
          )         

          expect(result).to eq nil
        end
      end    
    end

    describe '.get_disbursement' do
      context 'valid request' do
        before do
          data = read_file_fixture('disbursement.json')
          @parsed_data = JSON.parse(data)
          @stub = stub_request(:get, "https://api.xendit.co/v2/disbursements/" + @parsed_data['id'])
            .to_return(:status => 200, :body => data, :headers => {})     
        end

        it 'should return the disbursement fetched by the id' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_disbursement(id: @parsed_data['id'])

          expect(result.class.name).to eq 'XenditApi::Entities::Disbursement'
          expect(result.amount).to eq @parsed_data['amount']
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_disbursement(id: 'random_id')

          expect(result).to eq nil
        end
      end    
    end

    describe '.get_banks_for_virtual_account' do
      context 'valid request' do
        before do
          data = read_file_fixture('banks.json')
          @parsed_data = JSON.parse(data)          
          @stub = stub_request(:get, "https://api.xendit.co/available_virtual_account_banks")
            .to_return(:status => 200, :body => data, :headers => {})
        end

        it 'should return an array of banks' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_banks_for_virtual_account

          expect(result.class.name).to eq 'Array'
          expect(result.first.class.name).to eq 'XenditApi::Entities::Bank'
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_banks_for_virtual_account

          expect(result).to eq nil
        end
      end    
    end       

    describe '.get_banks_for_disbursement' do
      context 'valid request' do
        before do
          data = read_file_fixture('banks.json')
          @parsed_data = JSON.parse(data)          
          @stub = stub_request(:get, "https://api.xendit.co/available_disbursements_banks")
            .to_return(:status => 200, :body => data, :headers => {})
        end

        it 'should return an array of banks' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_banks_for_disbursement

          expect(result.class.name).to eq 'Array'
          expect(result.first.class.name).to eq 'XenditApi::Entities::Bank'
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_banks_for_disbursement

          expect(result).to eq nil
        end
      end    
    end       

    describe '.get_bank_account_data' do
      context 'valid request' do
        before do
          @stub = stub_request(:post, "https://api.xendit.co/bank_account_data_requests")
            .to_return(:status => 200, :body => '{}', :headers => {})          
        end

        it 'should return empty hash' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_bank_account_data(account_number: 'stubbed_number', bank_code: 'MANDIRI')

          expect(result).to eq Hash.new
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_bank_account_data(account_number: 'stubbed_number', bank_code: 'MANDIRI')

          expect(result).to eq nil
        end
      end    
    end

    describe '.charge_credit_card' do
      let(:data) { read_file_fixture('credit_card_charge.json') }
      let(:parsed_data) { JSON.parse(data) }

      context 'valid request' do
        before do          
          @stub = stub_request(:post, "https://api.xendit.co/credit_card_charges")
            .to_return(:status => 201, :body => data, :headers => {})     
        end

        it 'should return the charge created by the request' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.charge_credit_card(
            token: parsed_data['id'], 
            external_id: parsed_data['external_id'], 
            amount: parsed_data['capture_amount']
          )

          expect(result.class.name).to eq 'XenditApi::Entities::CardCharge'
          expect(result.capture_amount).to eq parsed_data['capture_amount']
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.charge_credit_card(
            token: parsed_data['id'], 
            external_id: parsed_data['external_id'], 
            amount: parsed_data['capture_amount']
          )        

          expect(result).to eq nil
        end
      end    
    end    
  end
end