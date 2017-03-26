module XenditApi
	module Entities
		class VirtualAccount < Base
			extend ModelAttribute

  		attribute :id,        				:string
  		attribute :owner_id,	  			:string
			attribute :external_id,	  		:string
			attribute :bank_code,	  			:string
			attribute :merchant_code,	  	:string
			attribute :name,	  					:string
			attribute :account_number,	  :string

		  def initialize(attributes = {})
		    set_attributes(attributes)
		  end
		end
	end
end