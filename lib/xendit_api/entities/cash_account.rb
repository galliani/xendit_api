module XenditApi
	module Entities
		class CashAccount < Base
			extend ModelAttribute

  		attribute :balance,        :integer
  		attribute :balance_cents,	 :integer

		  def initialize(attributes = {})
		    set_attributes(attributes)
		    @balance_cents = (balance.to_s + '00').to_i
		  end
		end
	end
end