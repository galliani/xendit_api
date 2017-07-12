require 'model_attribute'

module XenditApi
  module Entities
    class Base      
      require "xendit_api/entities/bank.rb"
      require "xendit_api/entities/card_charge.rb"
      require "xendit_api/entities/cash_account.rb"
      require "xendit_api/entities/disbursement.rb"
      require "xendit_api/entities/invoice.rb"
      require "xendit_api/entities/virtual_account.rb"
    end
  end
end