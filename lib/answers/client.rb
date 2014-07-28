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
  
  def self.client?
    return false if (defined?(@@client)).nil?
    return false if @@client.nil?
    
    true
  end
  
  # erases the current client, if one exists
  def self.reset!
    return if !client?
    #return if (defined?(@@client)).nil?
    @@client = nil
    return
  end
  
  # initialized client accessible from the Answers singleton
  def self.client
    if !client?
      raise Answers::Error.new "Answers Platform API not initialized. Call Answers.init."
    end
    
    @@client
  end
  
  class Client
    attr_reader :connection
    
    def initialize(config = {})
      # use the default
      url = Protocol::BASE_PATH
      
      # or use the provided url, if one is provided
      if config[:url]
        url = config[:url]
      end
      
      # put it in a hash
      faraday_defaults = {
        url: url 
      }
      
      @connection = Faraday.new(faraday_defaults) do |faraday|
        #faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.headers['Content-Type'] = Protocol::DEFAULT_CONTENT_TYPE
        faraday.headers[Protocol::EMAIL_HEADER_KEY] = config[:user_email] if config[:user_email]
        faraday.headers[Protocol::TOKEN_HEADER_KEY] = config[:user_token] if config[:user_token]
      end
    end
    
    def request(method, path, &block)
      response = @connection.send(method) do |req|
        req.url(path)
        block.call(req) if block_given?
      end
      
      handle_response(response)
    end
    
    def get(path, params=nil)
      request(:get, path) do |req|
        req.params = params if params
      end
    end
    
    def post(path, body=nil)
      request(:post, path) do |req|
        req.body = body.to_json if body
      end
    end
    
    def put(path, body=nil)
      request(:put, path) do |req|
        req.body = body.to_json if body
      end
    end
    
    def delete(path)
      request(:delete, path)
    end
    
    def handle_response(response)
      if response.status == 401
        raise Answers::Error.new "401 Unauthorized"
      end
        JSON.parse(response.body)
    end
  
  end

end
