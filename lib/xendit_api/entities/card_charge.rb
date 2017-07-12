module XenditApi
  module Entities
    class CardCharge < Base
      extend ModelAttribute

      attribute :id,   :string
      attribute :external_id,  :string
      attribute :capture_amount,   :integer
      attribute :business_id,  :string
      attribute :merchant_reference_code,  :string
      attribute :merchant_id,  :string
      attribute :created,  :string
      attribute :status,   :string
      attribute :eci,  :string

      def initialize(attributes = {})
        set_attributes(attributes)
      end
    end
  end
end