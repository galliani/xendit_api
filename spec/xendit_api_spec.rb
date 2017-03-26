require "spec_helper"

describe XenditApi do
  it "has a version number" do
    expect(XenditApi::VERSION).not_to be nil
  end

  it 'has the Xendit API base url set' do
    expect(XenditApi.base_url).to eq XenditApi::BASE_URL
  end
end
