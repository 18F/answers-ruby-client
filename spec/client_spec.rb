require 'spec_helper'
require 'pry'

describe Answers::Client do  
  context 'When no API keys are provided' do
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    
    it 'creates a Client instance when ::init is called' do
      expect do 
        Answers.reset!
        Answers.client
      end.to raise_error(Answers::Error)
      
      Answers.init
      
      expect(Answers.client).to(be_a(Answers::Client))
    end
  end
  
  context 'When API keys are provided' do
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    
    it 'appends those keys to the request header' do
      keys = {
        user_email: 'fake@email.tld',
        user_token: 'fake_token'
      }
      Answers.init keys
      
      headers = Answers.client.connection.headers
            
      expect(headers).to(include(
        Answers::Protocol::EMAIL_HEADER_KEY => keys[:user_email]),
        Answers::Protocol::TOKEN_HEADER_KEY => keys[:user_token]
      )
    end
  end
  
  context 'When the user must supply a non-default URL' do
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    
    it 'accepts a :url param in the constructor' do
      new_url = 'https://my-non-default.url/'
      Answers.init({
        url: new_url
      })
      
      expect(Answers.client.connection.build_url.to_s).to(eq(new_url))
    end
  end
  
  context 'Regardless of whether or not API keys are provided' do
    before(:all) { Answers.reset! }
    after(:all) { Answers.reset! }
    
    let(:client) do
      Answers.init
      Answers.client
    end

    it 'has a #get method' do
      expect(client).to(respond_to(:get))
    end
    
    it 'has a #post method' do
      expect(client).to(respond_to(:post))
    end
    
    it 'has a #put method' do
      expect(client).to(respond_to(:put))
    end
    
    it 'has a #delete method' do
      expect(client).to(respond_to(:delete))
    end
  end
end
