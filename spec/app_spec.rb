require_relative 'spec_helper'

describe 'Monitoring Service Agent Application' do

  let!(:secrets) {
    secrets = YAML.load_file('config/secrets.yml')
    secrets.fetch('test')
  }
  let!(:username) { secrets.fetch('username') }
  let!(:password) { secrets.fetch('password') }

  before(:each) { basic_authorize username, password }
  it 'should allow accessing root path' do
    get '/'

    expect(last_response).to be_ok
  end

  it 'should allow accessing start' do
    get '/start'

    expect(last_response).to be_ok
  end

  it 'should allow accessing stop' do
    get '/stop'

    expect(last_response).to be_ok
  end
end
