# XenditApi

A simple wrapper to interact with Xendit API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xendit_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xendit_api

## Usage

### Instantiating the client
  require 'xendit_api'

    client = XenditApi::Client.new(api_key: 'your_api_key')

### Get your cash balance

    client.get_cash_balance

### Name Validator
This is to look up the name of an account holder for any bank account in Indonesia, the response is an empty hash if it is uncached. The 'true' response will be delivered via callback to the designed URL.

   client.get_bank_account_data(account_number: '1234567899', bank_code: 'BCA')

### Get an invoice
To retrieve an existing invoice

    client.get_invoice(id: '579c8d61f23fa4ca35e52da4')

### Create an invoice
Create invoice to accept bank transfers

    client.create_invoice(
      external_id: 'demo_1475801962607', 
      payer_email: 'sample_email@xendit.co', 
      description: 'Trip to Bali', 
      amount: 230000
    )

### Get available banks for virtual_account
Retrieves the current list of banks Xendit support for creating virtual account.

    client.get_banks_for_virtual_accounts

### Create A Fixed Virtual Account
Create a fixed virtual account to accept bank transfers, callback will be sent everytime this FVA is paid.

    client.create_fixed_virtual_account(
      external_id: 'demo_virtual_account_1475459775872', 
      bank_code: 'BCA', 
      name: 'Rika Sutanto', 
      virtual_account_number: nil
    )
* Note that the virtual_account_number argument is optional

### Get available banks for disbursement
Retrieves the current list of banks Xendit support for disbursements.

    client.get_banks_for_disbursement

### Get a disbursement
Retrieves the current status of a disbursement. This is often used for checking the status of a transaction.

    client.get_disbursement(id: '57c9010f5ef9e7077bcb96b6')

### Create a disbursement
Create a disbursement order

    client.create_disbursement(
      idempotency_key: nil, 
      external_id: 'demo_1475459775872', 
      bank_code: 'BCA', 
      account_holder_name: 'Bob Jones', 
      account_number: '1231241231', 
      description: 'Reimbursement for shoes', 
      amount: 100000
    )

* Note that the idempotency_key argument is optional

### Charge credit card
Charge a cedit card using token returned by xendit.js

    client.charge_credit_card(
      external_id: 'Xendit', 
      token: '586f0ba2ab70de5d2b409e0d', 
      amount: 100000
    )

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xendit_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

