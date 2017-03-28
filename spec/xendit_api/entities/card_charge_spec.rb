require 'spec_helper'

module XenditApi::Entities
	describe CardCharge do
		it { should respond_to(:id) }
		it { should respond_to(:external_id) }
		it { should respond_to(:capture_amount) }
		it { should respond_to(:business_id) }
		it { should respond_to(:merchant_reference_code) }
		it { should respond_to(:merchant_id) }
		it { should respond_to(:created) }
		it { should respond_to(:status) }
		it { should respond_to(:eci) }
	end
end