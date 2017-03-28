module XenditApi
	module Entities
		class Bank < Base
			extend ModelAttribute

  		attribute :name,   :string
  		attribute :code,	 :string

		  def initialize(attributes = {})
		    set_attributes(attributes)
		  end
		end
	end
end