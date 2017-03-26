require "xendit_api/version"
require "xendit_api/client"
require "xendit_api/entities/base"

module XenditApi
  BASE_URL = 'https://api.xendit.co/'
  BASE_VERSION = '0'

  def self.base_url
  	@base_url = BASE_URL
  end
end
