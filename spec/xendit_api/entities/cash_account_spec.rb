require 'spec_helper'

module XenditApi::Entities
	describe CashAccount do
		it { should respond_to(:balance) }
		it { should respond_to(:balance_cents) }
	end
end