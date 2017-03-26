require 'spec_helper'

module XenditApi::Entities
	describe VirtualAccount do
		it { should respond_to(:id) }
		it { should respond_to(:owner_id) }
		it { should respond_to(:external_id) }
		it { should respond_to(:bank_code) }
		it { should respond_to(:merchant_code) }
		it { should respond_to(:name) }
		it { should respond_to(:account_number) }
	end
end