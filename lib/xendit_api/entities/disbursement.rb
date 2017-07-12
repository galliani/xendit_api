module XenditApi
  module Entities
    class Disbursement < Base
      extend ModelAttribute

      attribute :id,                        :string
      attribute :user_id,                   :string
      attribute :external_id,               :string
      attribute :amount,                    :integer
      attribute :bank_code,                 :string
      attribute :account_holder_name,       :string
      attribute :disbursement_description,  :string
      attribute :status,                    :string

      def initialize(attributes = {})
        set_attributes(attributes)
      end
    end
  end
end