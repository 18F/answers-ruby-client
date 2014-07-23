require 'faraday'
require 'json'

require 'answers/protocol'

module Answers
  
  def self.init(config = {})
    # check env vars by default
    defaulted = {
      user_email: ENV['ANSWERS_USER_EMAIL'],
      user_token: ENV['ANSWERS_USER_TOKEN']
    }
    # if credentials are passed, overwrite the defaults
    defaulted.merge!(config)
    
    # instantiate a client
    @@client = Client.new(config)
  end
  
  # initialized client accessible from the Answers singleton
  def self.client
    if @@client.nil?
      raise "Answers Platform API not initialized"
    end
    
    @@client
  end
  
  class Client
    attr_accessor :credentials
    
    def initialize(config=nil)
      faraday_defaults = {
        url: Protocol::BASE_PATH
      }
      
      @conn = Faraday.new(faraday_defaults) do |faraday|
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.headers['Content-Type'] = Protocol::DEFAULT_CONTENT_TYPE
        faraday.headers[Protocol::EMAIL_HEADER_KEY] = config[:user_email] if config[:user_email]
        faraday.headers[Protocol::TOKEN_HEADER_KEY] = config[:user_token] if config[:user_token]
      end
    end
    
    def get(path, params=nil)
      response = @conn.get do |req|
        req.url path
        req.params = params if params
      end
      
      throw_response_error!(response) if response_error?(response)
      
      JSON.parse(response.body)
    end
    
    def post(path, body=nil)
      response = @conn.post do |req|
        req.url path
        req.body = body.to_json if body
      end
      
      throw_response_error!(response) if response_error?(response)
      
      JSON.parse(response.body)
    end
    
    def put(path, body=nil)
      response = @conn.put do |req|
        req.url path
        req.body = body.to_json if body
      end
      
      throw_response_error!(response) if response_error?(response)
      
      
      JSON.parse(response.body)
    end
    
    def delete(path)
      response = @conn.delete(path)
      
      throw_response_error!(response) if response_error?(response)
      
      JSON.parse(response.body)
    end
    
    def response_error?(response)
      response.status == 401
    end
    
    def throw_response_error!(response)
      raise Answers::Error.new("HTTP Response error #{response.status}")
    end
  
  end

end

