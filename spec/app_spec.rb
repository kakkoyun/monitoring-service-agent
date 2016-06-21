require_relative 'spec_helper'

describe "Monitoring Service Agent Application" do

  it "should allow accessing root path" do
    get '/'

    expect(last_response).to be_ok
  end

  it "should allow accessing start" do
    get '/start'

    expect(last_response).to be_ok
  end

  it "should allow accessing stop" do
    get '/stop'

    expect(last_response).to be_ok
  end
end
