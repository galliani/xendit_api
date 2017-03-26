module XenditApi
	module Entities
		class CashAccount < Base
			extend ModelAttribute

  		attribute :balance,        :integer
  		attribute :balance_cents,	 :integer

		  def initialize(attributes = {})
		    set_attributes(attributes)
		  end
		end
	end
end