module XenditApi
  module Entities
    class Invoice < Base
      extend ModelAttribute

      attribute :id,                    :string
      attribute :user_id,               :string
      attribute :external_id,           :string
      attribute :is_high,               :boolean
      attribute :status,                :string
      attribute :merchant_name,         :string
      attribute :amount,                :integer
      attribute :billable_amount,       :integer
      attribute :taxable_amount,        :integer
      attribute :received_amount,       :integer
      attribute :payer_email,           :string
      attribute :description,           :string
      attribute :invoice_url,           :string
      attribute :xendit_fee_amount,     :integer
      attribute :expiry_date,           :string
      attribute :taxes,                 :json
      attribute :fees,                  :json
      attribute :available_banks,       :json

      def initialize(attributes = {})
        set_attributes(attributes)
      end
    end
  end
end