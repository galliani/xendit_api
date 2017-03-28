require 'spec_helper'

module XenditApi::Entities
	describe Bank do
		it { should respond_to(:name) }
		it { should respond_to(:code) }
	end
end