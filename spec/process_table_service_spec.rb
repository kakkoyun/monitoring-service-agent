require_relative 'spec_helper'
require_relative '../lib/http_service'
require_relative '../lib/process_table_service'

require 'pry'

RSpec.describe ProcessTableService, type: :model do

  describe 'call the process table usage service' do

    let!(:process_table) { [['foo', '4,5']] }

    let(:post_url) {
      'http://localhost:3000/api/v1/process_tables'
    }

    let(:payload) {
      { process_table: { process_table_items_attributes: [{ name: 'foo', cpu_usage_amount: '4,5' }] } }
    }


    let(:call) {
      ProcessTableService.new(base_url:      'http://localhost:3000/',
                              client_id:     'id',
                              client_secret: 'secret',
                              logger:        object_double('logger', info: nil),
                              process_table: process_table
      ).call
    }

    before(:each) {
      stub_request(:post, 'http://localhost:3000/oauth/token')
          .with(body:    { 'client_id' => 'id', 'client_secret' => 'secret', 'grant_type' => 'client_credentials' },
                headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: { access_token: 'token' }.to_json, headers: {})
    }

    it 'parses response for url' do
      stub_request(:post, post_url)
          .with(body: payload)
          .to_return(status: 201,
                     body:   { process_table_items: payload[:process_table][:process_table_items_attributes] }.to_json)
      result_array = call.process_table_items.map { |value| [value.name, value.cpu_usage_amount] }
      expect(result_array).to match_array(process_table)
    end
  end
end
