$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "xendit_api"
require 'webmock/rspec'
require 'capybara/rspec'
require 'json'
WebMock.disable_net_connect!

RSpec.configure do |config|
	config.treat_symbols_as_metadata_keys_with_true_values = true 
	config.run_all_when_everything_filtered = true
	config.filter_run :focus 
  config.order = 'random' 

  # Stubs
  # config.before(:each) do
  #   stub_request(:get, 'https://sheetsu.com/apis/foo')
  #     .with(
  #       headers: {
  #         'Accept' => '*/*',
  #         'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #         'User-Agent' => 'Ruby'
  #       }
  #      )
  #     .to_return(
  #       status: 200,
  #       body: '{"status": 200, "success": true, "result": []}',
  #       headers: {}
  #      )
  # end  
end