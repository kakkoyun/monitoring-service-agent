require_relative 'spec_helper'
require_relative '../lib/http_service'
require_relative '../lib/disk_usage_service'

RSpec.describe DiskUsageService, type: :model do

  describe 'call the disk usage service' do

    let!(:amount) { 5.7 }
    let!(:ratio) { 57.7 }

    let!(:fail_amount) { 'hodo' }
    let!(:fail_ratio) { 'hodo' }

    let(:post_url) {
      'http://localhost:3000/api/v1/disk_usages'
    }

    let(:payload) {
      { disk_usage: { amount: amount.to_s, ratio: ratio.to_s } }
    }


    let(:call) {
      DiskUsageService.new(base_url:      'http://localhost:3000/',
                          client_id:     'id',
                          client_secret: 'secret',
                          logger:        object_double('logger', info: nil),
                          amount:        amount,
                          ratio:         ratio
      ).call
    }

    let(:fail_call) {
      DiskUsageService.new(base_url:      'http://localhost:3000/',
                          client_id:     'id',
                          client_secret: 'secret',
                          logger:        object_double('logger', info: nil),
                          amount:        fail_amount,
                          ratio:         fail_ratio
      ).call
    }

    before(:each) {
      stub_request(:post, 'http://localhost:3000/oauth/token')
          .with(body:    { 'client_id' => 'id', 'client_secret' => 'secret', 'grant_type' => 'client_credentials' },
                headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: { access_token: 'token' }.to_json, headers: {})
    }

    it 'parses response for url' do
      stub_request(:post, post_url).with(body: payload).to_return(status: 201, body: '{ "amount": 5.7, "ratio": 57.7 }')
      expect(call.amount).to eq(amount)
      expect(call.ratio).to eq(ratio)
    end

    it 'raises exception on failure with wrong arguments' do
      stub_request(:post, post_url).with(body: { disk_usage: { amount: fail_amount, ratio: fail_ratio } }).to_return(status: 422)
      expect { fail_call }.to raise_error(HttpService::ResponseError)
    end
  end
end
