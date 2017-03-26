require 'spec_helper'

module XenditApi::Entities
	describe Disbursement do
		it { should respond_to(:id) }
		it { should respond_to(:user_id) }
		it { should respond_to(:external_id) }
		it { should respond_to(:amount) }
		it { should respond_to(:bank_code) }
		it { should respond_to(:account_holder_name) }
		it { should respond_to(:disbursement_description) }
		it { should respond_to(:status) }
	end
end