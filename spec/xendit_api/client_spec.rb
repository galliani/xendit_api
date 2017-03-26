require 'spec_helper'

module XenditApi
  describe Client do
    it 'takes an API key on initialization and convert it into token' do
      require "base64"

      api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='

      client = Client.new(api_key: api_key)
      appended_api_key = api_key + ':'
      tokenized_api_key = Base64.encode64(appended_api_key)

      expect(client.token).to eq tokenized_api_key 
    end
  end
end