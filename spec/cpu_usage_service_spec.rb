require_relative 'spec_helper'
require_relative '../lib/http_service'
require_relative '../lib/cpu_usage_service'

RSpec.describe CpuUsageService, type: :model do

  describe 'call the cpu usage service' do

    let!(:amount) { 5.7 }
    let!(:fail_amount) { 'hodo' }

    let(:post_url) {
      "http://localhost:3000/api/v1/cpu_usages"
    }

    let(:payload) {
      { cpu_usage: { amount: amount.to_s } }
    }


    let(:call) {
      CpuUsageService.new(base_url:      'http://localhost:3000/',
                          client_id:     'id',
                          client_secret: 'secret',
                          logger:        object_double("logger", info: nil),
                          amount:        amount
      ).call
    }

    let(:fail_call) {
      CpuUsageService.new(base_url:      'http://localhost:3000/',
                          client_id:     'id',
                          client_secret: 'secret',
                          logger:        object_double("logger", info: nil),
                          amount:        fail_amount
      ).call
    }

    before(:each) {
      stub_request(:post, "http://localhost:3000/oauth/token")
          .with(body:    { "client_id" => "id", "client_secret" => "secret", "grant_type" => "client_credentials" },
                headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: { access_token: "token" }.to_json, headers: {})
    }

    it 'parses response for url' do
      stub_request(:post, post_url).with(body: payload).to_return(status: 201, body: '{ "amount": 5.7 }')
      expect(call.amount).to eq(amount)
    end

    it 'raises exception on failure with wrong amount' do
      stub_request(:post, post_url).with(body: { cpu_usage: { amount: fail_amount.to_s } }).to_return(status: 422)
      expect { fail_call }.to raise_error(HttpService::ResponseError)
    end
  end
end
