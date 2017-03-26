require 'spec_helper'

module XenditApi::Entities
	describe Invoice do
		it { should respond_to(:id) }
		it { should respond_to(:user_id) }
		it { should respond_to(:external_id) }
		it { should respond_to(:is_high) }
		it { should respond_to(:status) }
		it { should respond_to(:merchant_name) }
		it { should respond_to(:amount) }
		it { should respond_to(:billable_amount) }
		it { should respond_to(:received_amount) }
		it { should respond_to(:payer_email) }
		it { should respond_to(:description) }
		it { should respond_to(:invoice_url) }
		it { should respond_to(:xendit_fee_amount) }
		it { should respond_to(:expiry_date) }
		it { should respond_to(:taxes) }
		it { should respond_to(:fees) }
		it { should respond_to(:available_banks) }
	end
end